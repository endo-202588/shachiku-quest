require "rails_helper"

RSpec.describe "tasks", type: :system do
  let(:user) { create(:user, password: "password") }

  before do
    # ログインの前処理
    visit login_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password"
    click_button "冒険の扉を開く"

    choose "平和"
    fill_in "メモ", with: "余裕あります"
    click_button "ステータスを登録"

    visit new_task_path
  end

  def fill_task_title(title = "テストタイトル")
    title_label = find("label", text: "タイトル", match: :first)
    title_input = title_label.find(:xpath, "following-sibling::input[1]")
    title_input.set(title)
  end

  def select_by_label(label_text, option_text)
    label  = find("label", text: label_text, match: :first)
    select = label.find(:xpath, "following-sibling::select[1]")
    select.find("option", text: option_text, match: :first).select_option
  end

  describe "タスク登録" do
    it "進行中のタスクを登録するとタスク一覧に遷移する" do
      fill_task_title

      select_by_label("ステータス", "進行中")

      click_button "タスクを一括登録"

      expect(page).to have_current_path(tasks_path)
      expect(page).to have_content("タスク一覧")
    end

    it "ヘルプ要請のタスクを登録するとタスク一覧に遷移する" do
      within first(".task-field") do
        fill_task_title("ヘルプ要請タスク")

        # ステータス: ヘルプ要請 を選択
        select_by_label("ステータス", "ヘルプ要請")

        expect(page).to have_selector("label", text: "必要時間", wait: 5)

        select_by_label("必要時間", "30分")

        select_by_label("付与ポイント", "10")
      end

      click_button "タスクを一括登録"

      expect(page).to have_current_path(tasks_path)
      expect(page).to have_content("タスク一覧")
    end
  end
end