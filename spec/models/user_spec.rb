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
end
