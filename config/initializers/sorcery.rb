Rails.application.config.sorcery.submodules = [
  :reset_password
]

Rails.application.config.sorcery.configure do |config|
  config.user_class = "User"

  config.user_config do |user|
    user.reset_password_mailer = :user_mailer
    user.reset_password_email_method_name = :reset_password_email
    user.reset_password_time_between_emails = 60
    user.reset_password_expiration_period = 2.hours
  end
end
