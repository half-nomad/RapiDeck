require "test_helper"

class SlidesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_slide_url
    assert_response :success
  end

  test "should redirect when document is missing" do
    post slides_url, params: { api_key: "test_key" }
    assert_response :redirect
    assert_equal "문서 내용을 입력해주세요.", flash[:error]
  end

  test "should redirect when api_key is missing" do
    post slides_url, params: { document: "Test document" }
    assert_response :redirect
    assert_equal "Gemini API 키를 입력해주세요.", flash[:error]
  end

  test "should redirect to new_slide when no current slide in session" do
    get current_slide_url
    assert_redirected_to new_slide_path
    assert_equal "슬라이드를 찾을 수 없습니다.", flash[:error]
  end
end
