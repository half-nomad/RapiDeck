# frozen_string_literal: true

require "httparty"

class GeminiClient
  include HTTParty
  base_uri "https://generativelanguage.googleapis.com"

  attr_reader :api_key

  def initialize(api_key)
    @api_key = api_key
    raise ArgumentError, "API key is required" if @api_key.blank?
  end

  def generate_slide(user_prompt)
    response = self.class.post(
      "/v1beta/models/gemini-pro:generateContent",
      query: { key: @api_key },
      headers: { "Content-Type" => "application/json" },
      body: request_body(user_prompt).to_json,
      timeout: 120 # 2분 타임아웃
    )

    if response.success?
      extract_html(response.parsed_response)
    else
      handle_error(response)
    end
  rescue HTTParty::Error, Net::OpenTimeout, Net::ReadTimeout => e
    raise GeminiApiError, "네트워크 오류: #{e.message}"
  end

  private

  def request_body(user_prompt)
    {
      contents: [
        {
          parts: [
            { text: system_prompt },
            { text: user_prompt }
          ]
        }
      ]
    }
  end

  def system_prompt
    @system_prompt ||= File.read(
      Rails.root.join("docs", "SYSTEM_PROMPT.md")
    )
  end

  def extract_html(response_data)
    html_code = response_data.dig("candidates", 0, "content", "parts", 0, "text")

    if html_code.blank?
      raise GeminiApiError, "Gemini API가 빈 응답을 반환했습니다."
    end

    html_code
  end

  def handle_error(response)
    error_message = case response.code
    when 400
      "잘못된 요청입니다. API 키를 확인해주세요."
    when 403
      "API 키가 유효하지 않습니다."
    when 429
      "API 요청 한도를 초과했습니다. 잠시 후 다시 시도해주세요."
    when 500..599
      "Gemini API 서버 오류입니다. 잠시 후 다시 시도해주세요."
    else
      "알 수 없는 오류가 발생했습니다."
    end

    raise GeminiApiError, "#{error_message} (코드: #{response.code})"
  end
end

class GeminiApiError < StandardError; end
