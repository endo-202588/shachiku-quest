require "rails_helper"

RSpec.describe "Login", type: :system do
  let(:user) { create(:user, password: "password") }

  describe "ログイン後の遷移" do
    it "ログインするとステータス登録画面に遷移すること" do
      visit login_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: "password"
      click_button "冒険の扉を開く"

      expect(page).to have_current_path(new_status_path)
      expect(page).to have_content("ステータス")
      end
    end
  end
end
