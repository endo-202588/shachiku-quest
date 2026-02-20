require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should redirect to login when not logged in" do
    get dashboard_path

    # 302 を期待
    assert_response :redirect

    # Sorcery の `require_login` が飛ばしているのは /login なので、
    # ルーティングに `get "login", to: "user_sessions#new"` があれば login_path でOK
    assert_redirected_to login_path
  end
end
