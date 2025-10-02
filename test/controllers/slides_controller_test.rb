require "test_helper"

class SlidesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get slides_new_url
    assert_response :success
  end

  test "should get create" do
    get slides_create_url
    assert_response :success
  end

  test "should get show" do
    get slides_show_url
    assert_response :success
  end
end
