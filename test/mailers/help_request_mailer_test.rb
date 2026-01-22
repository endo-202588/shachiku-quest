require "test_helper"

class HelpRequestMailerTest < ActionMailer::TestCase
  test "completed_notify" do
    mail = HelpRequestMailer.completed_notify
    assert_equal "Completed notify", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
