require "rails_helper"

RSpec.describe "Statuses", type: :system do
  let(:user) { create(:user, password: "password") }

  before do
    # ログインの前処理
    visit login_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password"
    click_button "冒険の扉を開く"
  end

  describe "ステータス登録" do
    it "ステータスを登録するとタスク作成画面に遷移する" do
      choose "平和"
      fill_in "メモ", with: "余裕あります"
      click_button "ステータスを登録"

      expect(page).to have_current_path(new_task_path)
      expect(page).to have_content("タスクを登録")
    end
  end
end