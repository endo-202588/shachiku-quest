require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user, password: "password", password_confirmation: "password") }

  describe "POST /login" do
    it "logs in with correct credentials" do
      post login_path, params: {
        email: user.email,
        password: "password"
      }

      # Sorcery: logged_in? は session[:user_id] を見ている
      expect(session[:user_id]).to eq(user.id.to_s)
      expect(response).to redirect_to(new_status_path)
    end

    it "fails with wrong password" do
      post login_path, params: {
        email: user.email,
        password: "wrongpassword"
      }

      expect(session[:user_id]).to be_nil
      expect(response.status).to eq(422) # エラー表示ページ（new）
    end
  end

  describe "DELETE /logout" do
    it "logs out successfully" do
      post login_path, params: { email: user.email, password: "password" }

      delete logout_path

      # ログアウト時にまず root_path にリダイレクトすることを確認
      expect(response).to redirect_to(root_path)

      # 最終ページは 200 OK（トップページ表示）
      follow_redirect!
      expect(response).to have_http_status(:ok)

      # 最後に、ログインが必要なページに行くと login_path に飛ぶ → ログアウト確認
      get dashboard_path
      expect(response).to redirect_to(login_path)
    end
  end
end
