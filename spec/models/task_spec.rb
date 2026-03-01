require "rails_helper"

RSpec.describe Task, type: :model do
  it "has a valid factory" do
    task = build(:task)
    expect(task).to be_valid
  end

  describe "associations" do
    it "belongs to a user" do
      task = build(:task, user: nil)

      expect(task).to be_invalid
      expect(task.errors[:user]).to be_present
    end
  end

  describe "validations" do
    it "is invalid without a title" do
      task = build(:task, title: nil)

      expect(task).to be_invalid
      expect(task.errors[:title]).to be_present
    end

    it "is invalid without a status" do
      task = build(:task, status: nil)

      expect(task).to be_invalid
      expect(task.errors[:status]).to be_present
    end
  end

  describe "enum status" do
    it "has defined statuses" do
      expect(Task.statuses.keys).to contain_exactly(
        "in_progress", "help_request", "complete"
      )
    end

    it "can be set to help_request" do
      task = build(:task, status: :help_request)

      expect(task.help_request?).to be true
    end

    it "is in_progress by default" do
      task = create(:task)

      expect(task.in_progress?).to be true
    end

    it "can be set to complete" do
      task = build(:task, status: :complete)

      expect(task.complete?).to be true
    end
  end
end
