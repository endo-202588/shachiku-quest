require "test_helper"

class BulkTasksControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get bulk_tasks_new_url
    assert_response :success
  end

  test "should get create" do
    get bulk_tasks_create_url
    assert_response :success
  end
end
