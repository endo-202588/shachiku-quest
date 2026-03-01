require "rails_helper"

RSpec.describe User, type: :model do
  it "has a valid factory" do
    user = build(:user)
    expect(user).to be_valid
  end

  describe "validations" do
    it "is invalid without an email" do
      user = build(:user, email: nil)
      user.valid?

      expect(user.errors[:email]).to be_present
    end

    it "is invalid with a duplicate email" do
      create(:user, email: "test@example.com")
      user = build(:user, email: "test@example.com")
      user.valid?

      expect(user.errors[:email]).to be_present
    end

    it "is invalid without a password" do
      user = build(:user, password: nil, password_confirmation: nil)
      user.valid?

      expect(user.errors[:password]).to be_present
    end

    it "is invalid when password is shorter than 4 characters" do
      user = build(:user,
                  password: "abc",
                  password_confirmation: "abc")
      user.valid?

      expect(user.errors[:password]).to be_present
    end

    it "is valid when password is 4 characters or more" do
      user = build(:user)
      user.password = "abcd"
      user.password_confirmation = "abcd"

      expect(user).to be_valid
    end
  end

  describe "dependent destroy" do
    it "destroys associated statuses when destroyed" do
      user = create(:user)
      create(:status, user: user)

      expect { user.destroy }.to change { Status.count }.by(-1)
    end

    it "destroys associated tasks when destroyed" do
      user = create(:user)
      create(:task, user: user)

      expect { user.destroy }.to change { Task.count }.by(-1)
    end

    it "nullifies helper_id of received help_requests when destroyed" do
      helper = create(:user)
      requester = create(:user)
      task = create(:task, user: requester)

      hr = create(:help_request, task: task, helper: helper)

      helper.destroy
      hr.reload

      expect(hr.helper_id).to be_nil
    end

    it "destroys received_notifications when destroyed" do
      user = create(:user)
      sender = create(:user)

      create(:notification, recipient: user, sender: sender)

      expect { user.destroy }.to change { Notification.count }.by(-1)
    end
  end
end
