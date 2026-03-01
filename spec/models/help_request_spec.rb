require "rails_helper"

RSpec.describe HelpRequest, type: :model do
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
