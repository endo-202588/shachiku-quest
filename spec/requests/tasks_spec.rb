require "rails_helper"

RSpec.describe "Tasks", type: :request do
  let(:user) { create(:user, password: "password", password_confirmation: "password") }

  before do
    allow(DailyResetService).to receive(:call)  # ← Dashboard と同じ
  end

  describe "GET /tasks" do
    context "when not logged in" do
      it "redirects to login" do
        get tasks_path

        expect(response).to redirect_to(login_path)
      end
    end

    context "when logged in but NO today_status" do
      before do
        log_in(user)
      end

      it "redirects to new status page" do
        get tasks_path

        expect(response).to redirect_to(new_status_path(date: Date.current))
      end
    end

    context "when logged in and has today_status" do
      before do
        log_in(user)
        create(:status, user: user)
      end

      let!(:my_task1) { create(:task, user: user, title: "My Task 1") }
      let!(:my_task2) { create(:task, user: user, title: "My Task 2") }
      let!(:other_task) { create(:task, title: "Other Task") }

      it "returns http success" do
        get tasks_path
        expect(response).to have_http_status(:ok)
      end

      it "shows only current_user tasks" do
        get tasks_path
        body = response.body

        expect(body).to include("My Task 1")
        expect(body).to include("My Task 2")
        expect(body).not_to include("Other Task")
      end
    end
  end
end