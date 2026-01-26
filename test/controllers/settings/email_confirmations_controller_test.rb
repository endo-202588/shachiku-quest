require "test_helper"

class Settings::EmailConfirmationsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get settings_email_confirmations_show_url
    assert_response :success
  end
end
