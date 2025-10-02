class SlidesController < ApplicationController
  def new
  end

  def create
    document_text = params[:document]
    api_key = params[:api_key]

    if document_text.blank?
      flash[:error] = "문서 내용을 입력해주세요."
      redirect_to new_slide_path and return
    end

    if api_key.blank?
      flash[:error] = "Gemini API 키를 입력해주세요."
      redirect_to new_slide_path and return
    end

    begin
      # 1. 문서 파싱
      parser = DocumentParser.new(document_text)
      parsed_data = parser.parse

      flash[:warning] = parsed_data[:warning_message] if parsed_data[:truncated]

      # 2. Gemini API 호출
      gemini_client = GeminiClient.new(api_key)
      html_code = gemini_client.generate_slide(parsed_data[:content])

      # 3. 슬라이드 생성
      generator = SlideGenerator.new(html_code: html_code)
      @slide_data = generator.generate

      # 4. 원본 문서와 API 키를 세션에 저장 (채팅 수정용)
      @slide_data[:original_document] = parsed_data[:content]
      session[:current_slide] = @slide_data
      session[:api_key] = api_key
      session[:original_document] = parsed_data[:content]
      session[:chat_messages] = [] # 채팅 이력 초기화

      redirect_to slide_path("current")
    rescue GeminiApiError => e
      flash[:error] = e.message
      redirect_to new_slide_path
    rescue StandardError => e
      flash[:error] = "슬라이드 생성 중 오류가 발생했습니다: #{e.message}"
      redirect_to new_slide_path
    end
  end

  def show
    @slide_data = session[:current_slide]

    if @slide_data.nil?
      flash[:error] = "슬라이드를 찾을 수 없습니다."
      redirect_to new_slide_path
    end
  end

  def update
    message = params[:message]

    if message.blank?
      flash[:error] = "메시지를 입력해주세요."
      redirect_to slide_path("current") and return
    end

    @slide_data = session[:current_slide]

    if @slide_data.nil?
      flash[:error] = "슬라이드를 찾을 수 없습니다."
      redirect_to new_slide_path and return
    end

    begin
      # 1. 세션 초기화 (처음 채팅 시)
      session[:chat_messages] ||= []
      session[:original_document] ||= @slide_data[:original_document] || ""
      session[:api_key] ||= params[:api_key] || session[:api_key]

      if session[:api_key].blank?
        flash[:error] = "API 키가 없습니다. 새 슬라이드를 생성해주세요."
        redirect_to new_slide_path and return
      end

      # 2. 사용자 메시지 저장
      session[:chat_messages] << {
        role: "user",
        content: message,
        timestamp: Time.current.to_s
      }

      # 3. 대화 이력을 포함한 프롬프트 생성
      conversation_history = session[:chat_messages].map do |msg|
        "#{msg[:role] == 'user' ? '사용자' : 'AI'}: #{msg[:content]}"
      end.join("\n\n")

      user_prompt = <<~PROMPT
        원본 문서:
        #{session[:original_document]}

        이전 대화 이력:
        #{conversation_history}

        위 대화 내용을 바탕으로 슬라이드를 수정해주세요.
      PROMPT

      # 4. Gemini API 호출
      gemini_client = GeminiClient.new(session[:api_key])
      html_code = gemini_client.generate_slide(user_prompt)

      # 5. AI 응답 저장
      session[:chat_messages] << {
        role: "assistant",
        content: "슬라이드를 수정했습니다.",
        timestamp: Time.current.to_s
      }

      # 6. 슬라이드 재생성
      generator = SlideGenerator.new(html_code: html_code)
      @slide_data = generator.generate
      @slide_data[:original_document] = session[:original_document]

      # 7. 세션 업데이트
      session[:current_slide] = @slide_data

      flash[:success] = "슬라이드가 수정되었습니다."
      redirect_to slide_path("current")
    rescue GeminiApiError => e
      # 실패한 사용자 메시지 제거
      session[:chat_messages].pop
      flash[:error] = e.message
      redirect_to slide_path("current")
    rescue StandardError => e
      session[:chat_messages].pop
      flash[:error] = "슬라이드 수정 중 오류가 발생했습니다: #{e.message}"
      redirect_to slide_path("current")
    end
  end
end
