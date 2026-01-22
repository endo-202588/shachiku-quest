# Preview all emails at http://localhost:3000/rails/mailers/help_request_mailer
class HelpRequestMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/help_request_mailer/completed_notify
  def completed_notify
    HelpRequestMailer.completed_notify
  end
end
