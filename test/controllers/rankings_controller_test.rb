require "test_helper"

class RankingsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get rankings_show_url
    assert_response :success
  end
end
