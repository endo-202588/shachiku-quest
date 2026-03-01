require "rails_helper"

RSpec.describe Status, type: :model do
  it "has a valid factory" do
    status = build(:status)
    expect(status).to be_valid
  end

  describe "associations" do
    it "belongs to a user" do
      status = build(:status, user: nil)
      status.valid?

      expect(status.errors[:user]).to be_present
    end
  end

  describe "enum status_type" do
    it "has defined status types" do
      expect(Status.status_types.keys).to contain_exactly(
        "peaceful", "tired", "busy",
        "very_busy", "overloaded", "day_off"
      )
    end

    it "can be set to busy" do
      status = build(:status, status_type: :busy)
      expect(status.busy?).to be true
    end
  end

  describe "validations" do
    it "does not allow duplicate status for the same user on the same date" do
      user = create(:user)
      create(:status, user: user, status_date: Date.current)

      duplicate_status = build(:status, user: user, status_date: Date.current)

      expect(duplicate_status).to be_invalid
      expect(duplicate_status.errors[:status_date]).to be_present
    end

    it "is invalid without a status_date" do
      status = build(:status, status_date: nil)

      expect(status).to be_invalid
      expect(status.errors[:status_date]).to be_present
    end

    it "is invalid without a status_type" do
      status = build(:status, status_type: nil)

      expect(status).to be_invalid
      expect(status.errors[:status_type]).to be_present
    end
  end
end
