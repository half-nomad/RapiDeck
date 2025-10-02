# frozen_string_literal: true

class SlideGenerator
  attr_reader :html_code, :title, :content_type

  def initialize(html_code:, title: nil, content_type: nil)
    @html_code = html_code
    @title = title || extract_title_from_html
    @content_type = content_type
  end

  def generate
    {
      title: @title,
      content_type: @content_type,
      html_code: @html_code,
      generated_at: Time.current
    }
  end

  private

  def extract_title_from_html
    # HTML에서 첫 번째 h1 또는 title 태그 추출
    if @html_code =~ /<h1[^>]*>(.*?)<\/h1>/m
      Regexp.last_match(1).strip
    elsif @html_code =~ /<title[^>]*>(.*?)<\/title>/m
      Regexp.last_match(1).strip
    else
      "슬라이드 #{Time.current.strftime('%Y-%m-%d %H:%M')}"
    end
  end
end
