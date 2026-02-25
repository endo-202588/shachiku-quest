require "rails_helper"

RSpec.describe "Dashboard", type: :request do
  let(:user) { create(:user) }

  before do
    allow(DailyResetService).to receive(:call)
  end

  describe "GET /dashboard" do
    context "when not logged in" do
      it "redirects to login" do
        get dashboard_path

        expect(response).to redirect_to(login_path)
        expect(flash[:danger]).to eq "ログインしてください"
      end
    end

    context "when logged in and has NO today_status" do
      before do
        log_in(user)
      end

      it "redirects to new status page" do
        get dashboard_path
        expect(response).to redirect_to(new_status_path(date: Date.current))
        expect(flash[:alert]).to eq "本日のステータスを登録してください"
      end
    end

    context "when logged in and has today_status" do
      before do
        log_in(user)
        # 今日の日付のステータスを1件作っておく
        create(:status, user: user)
      end

      it "returns http success" do
        get dashboard_path

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
