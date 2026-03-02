require "rails_helper"

RSpec.describe "HelpRequests Flow", type: :request do
  let(:requester) { create(:user, password: "password") }
  let(:helper)    { create(:user, password: "password") }

  before do
    allow(DailyResetService).to receive(:call)

    post login_path, params: {
      email: requester.email,
      password: "password"
    }
    follow_redirect!
    expect(response.body).to include("ログアウト")
    create(:status, user: requester, status_date: Date.current)
  end

  it "creates a help_request via task update and completes it" do
    task = create(:task, user: requester)

    expect {
      patch task_path(task), params: {
        task: {
          status: "help_request",
          help_request_attributes: {
            required_time: "one_hour",
            virtue_points: 10
          }
        }
      }
    }.to change(HelpRequest, :count).by(1)

    expect(response).to redirect_to(tasks_path) # 実際の遷移先に合わせる
    follow_redirect!
    expect(response.body).to include("タスクを更新しました")

    help_request = HelpRequest.last

    expect(help_request.task).to eq(task)
    expect(help_request.status).to eq("open")
    expect(help_request.required_time).to eq("one_hour")
    expect(help_request.virtue_points).to eq(10)

    # マッチング
    help_request.update!(status: :matched, helper: helper)
    help_request.update!(status: :completed)

    expect(help_request.completed?).to be true
  end
end
