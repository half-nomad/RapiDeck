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

      # 임시로 세션에 저장 (Week 4에서 DB로 변경)
      session[:current_slide] = @slide_data

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
end
