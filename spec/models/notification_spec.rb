require "rails_helper"

RSpec.describe Notification, type: :model do
  describe "enum message_type" do
    it "has defined message types" do
      expect(Notification.message_types.keys).to contain_exactly(
        "matched", "completed", "thanks"
      )
    end

    it "can be set to thanks" do
      notification = build(:notification, message_type: :thanks)
      expect(notification.thanks?).to be true
    end
  end

  describe "scopes" do
    it "returns only unread notifications" do
      unread = create(:notification, read_at: nil)
      read = create(:notification, read_at: Time.current)

      expect(Notification.unread).to include(unread)
      expect(Notification.unread).not_to include(read)
    end
  end

  describe "#read!" do
    it "sets read_at when unread" do
      notification = create(:notification, read_at: nil)

      notification.read!
      notification.reload

      expect(notification.read_at).not_to be_nil
    end
  end
end
