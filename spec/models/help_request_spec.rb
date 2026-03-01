require "rails_helper"

RSpec.describe HelpRequest, type: :model do
  describe "enum status" do
    it "has defined statuses" do
      expect(HelpRequest.statuses.keys).to contain_exactly(
        "open", "matched", "completed", "cancelled"
      )
    end

    it "can be set to matched" do
      hr = build(:help_request, status: :matched)

      expect(hr.matched?).to be true
    end

    it "is open by default" do
      hr = create(:help_request)

      expect(hr.open?).to be true
    end
  end

  describe "enum required_time" do
    it "has defined required_times" do
      expect(HelpRequest.required_times.keys).to contain_exactly(
        "half_hour",
        "one_hour",
        "one_and_half_hours",
        "two_hours",
        "long_time"
      )
    end

    it "can be set to two_hours" do
      hr = build(:help_request, required_time: :two_hours)

      expect(hr.two_hours?).to be true
    end
  end

  describe "associations" do
    it "belongs to a task" do
      hr = build(:help_request, task: nil)

      expect(hr).to be_invalid
      expect(hr.errors[:task]).to be_present
    end
  end

  describe "helper association" do
    it "is valid without a helper" do
      hr = build(:help_request, helper: nil)

      expect(hr).to be_valid
    end

    it "can belong to a helper" do
      helper = create(:user)
      hr = build(:help_request, helper: helper)

      expect(hr.helper).to eq(helper)
    end
  end

  describe "dependent destroy" do
    it "destroys associated conversation when destroyed" do
      hr = create(:help_request)
      conversation = create(:conversation, help_request: hr)

      expect { hr.destroy }.to change { Conversation.count }.by(-1)
    end
  end

  describe ".reset_yesterday_matched_all!" do
    let(:yesterday) { Date.current - 1 }
    let(:today)     { Date.current }

    let(:requester) { create(:user) }
    let(:helper)    { create(:user) }

    context "完了通知なしの matched" do
      it "open に戻り、conversation が削除される" do
        hr = create(
          :help_request,
          status: :matched,
          matched_on: yesterday,
          helper: helper,
          completed_notified_at: nil
        )

        create(:conversation, help_request: hr)

        described_class.reset_yesterday_matched_all!(now: today)

        hr.reload

        expect(hr.status).to eq("open")
        expect(hr.conversation).to be_nil
      end
    end

    context "完了通知ありの matched" do
      it "completed になり、conversation が削除される" do
        hr = create(
          :help_request,
          status: :matched,
          matched_on: yesterday,
          helper: helper,
          task: create(:task, user: requester),
          completed_notified_at: Time.current
        )

        create(:conversation, help_request: hr)

        described_class.reset_yesterday_matched_all!(now: today)

        hr.reload

        expect(hr.status).to eq("completed")
        expect(hr.conversation).to be_nil
      end
    end

    context "今日 matched のもの" do
      it "何も変更されない" do
        hr = create(
          :help_request,
          status: :matched,
          matched_on: today,
          helper: helper
        )

        described_class.reset_yesterday_matched_all!(now: today)

        hr.reload

        expect(hr.status).to eq("matched")
      end
    end
  end
end
