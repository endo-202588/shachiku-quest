require "rails_helper"

RSpec.describe "Dashboard", type: :request do
  let(:user) { create(:user) }
  let(:ua) { "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36" }

  describe "GET /dashboard" do
    context "when not logged in" do
      it "redirects to login" do
        get dashboard_path, headers: { "User-Agent" => ua }
        puts response.body
        expect(response).to redirect_to(login_path)
      end
    end

    context "when logged in and has NO today_status" do
      before do
        log_in(user)
      end

      it "redirects to new status page" do
        get dashboard_path, headers: { "User-Agent" => ua }
        expect(response).to redirect_to(new_status_path(date: Date.current))
      end
    end
  end
end
