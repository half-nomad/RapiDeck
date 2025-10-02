# frozen_string_literal: true

class DocumentParser
  MAX_PAGES = 30
  CHARS_PER_PAGE = 500 # 대략적인 기준 (한글 포함)

  attr_reader :document_text

  def initialize(document_text)
    @document_text = document_text.to_s.strip
  end

  def parse
    {
      content: truncated_content,
      page_count: estimated_page_count,
      truncated: truncated?,
      warning_message: warning_message
    }
  end

  private

  def truncated_content
    return @document_text if @document_text.length <= max_chars

    @document_text[0...max_chars]
  end

  def max_chars
    @max_chars ||= MAX_PAGES * CHARS_PER_PAGE
  end

  def estimated_page_count
    @estimated_page_count ||= (@document_text.length / CHARS_PER_PAGE.to_f).ceil
  end

  def truncated?
    estimated_page_count > MAX_PAGES
  end

  def warning_message
    return nil unless truncated?

    "입력 문서가 #{estimated_page_count}페이지로 #{MAX_PAGES}페이지를 초과했습니다. " \
    "처음 #{MAX_PAGES}페이지만 처리됩니다."
  end
end
