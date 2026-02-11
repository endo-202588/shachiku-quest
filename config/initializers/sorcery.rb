Rails.application.config.sorcery.submodules = [
  :reset_password
]

Rails.application.config.sorcery.configure do |config|
  config.user_class = "User"

  config.user_config do |user|
    # reset_password 用の設定は "user" 側に書く
    user.reset_password_mailer = UserMailer
    user.reset_password_email_method_name = :reset_password_email
    user.reset_password_time_between_emails = 60
    user.reset_password_expiration_period = 2.hours.to_i
  end
end
