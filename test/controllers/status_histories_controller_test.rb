require "test_helper"

class StatusHistoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get status_histories_index_url
    assert_response :success
  end
end
