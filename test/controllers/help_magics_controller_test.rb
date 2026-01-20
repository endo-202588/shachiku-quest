require "test_helper"

class HelpMagicsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get help_magics_new_url
    assert_response :success
  end

  test "should get create" do
    get help_magics_create_url
    assert_response :success
  end
end
