require "test_helper"

class Manager::StaffConditionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get manager_staff_conditions_index_url
    assert_response :success
  end
end
