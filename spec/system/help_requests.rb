require "rails_helper"

RSpec.describe "help_requests matching", type: :system do
  let(:requester) { create(:user, password: "password") }
  let(:helper)    { create(:user, password: "password") }

  #
  # 共通ログイン処理
  #
  def login(user)
    visit login_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password"
    click_button "冒険の扉を開く"
  end

  #
  # ステータス登録
  #
  def register_status
    choose "平和"
    fill_in "メモ", with: "余裕あります"
    click_button "ステータスを登録"
  end

  #
  # ヘルプ要請タスク作成
  #
  def create_help_task
    visit new_task_path

    within first(".task-field") do
      title_label = find("label", text: "タイトル", match: :first)
      title_input = title_label.find(:xpath, "following-sibling::input[1]")
      title_input.set("ヘルプ要請タスク")

      select_label = find("label", text: "ステータス", match: :first)
      select_box   = select_label.find(:xpath, "following-sibling::select[1]")
      select_box.find("option", text: "ヘルプ要請").select_option

      select_by_label("必要時間", "30分")
      select_by_label("付与ポイント", "10")
    end

    click_button "タスクを一括登録"
  end

  def select_by_label(label_text, option_text)
    label  = find("label", text: label_text, match: :first)
    select = label.find(:xpath, "following-sibling::select[1]")
    select.find("option", text: option_text, match: :first).select_option
  end

  #
  # ==========================
  #
  describe "ヘルプマッチング" do
    it "魔法を使うとマッチングされる" do
      #
      # ① ヘルプ要請者ログイン
      #
      login(requester)
      register_status
      create_help_task

      #
      # ② ログアウト
      #
      click_button "ログアウト", match: :first

      #
      # ③ ヘルパーログイン
      #
      login(helper)
      register_status

      #
      # ④ ヘルプ一覧へ
      #
      visit help_requests_tasks_path

      expect(page).to have_content("シャチークの給湯室")

      #
      # ⑤ 魔法を使う（ボタン名は実装に合わせる）
      #
      click_link "魔法を登録する"

      select "ベハーフ（30分）", from: "お手伝い可能な時間"
      click_button "魔法を登録"

      click_button "この仕事の仲間になる", match: :first
      #
      # ⑥ マッチング確認
      #
      expect(page).to have_content("仲間になりました！", wait: 5)
      expect(page).to have_content(requester.decorate.full_name)

      help_request = HelpRequest.last
      expect(help_request.status).to eq("matched")
      expect(help_request.helper_id).to eq(helper.id)
    end
  end
end
