if Rails.env.development?
  LetterOpenerWeb.configure do |config|
    config.letters_location = Rails.root.join("tmp", "letter_opener")
  end

  Rails.application.config.to_prepare do
    next unless defined?(LetterOpenerWeb::LettersController)

    LetterOpenerWeb::LettersController.class_eval do
      skip_before_action :verify_authenticity_token, raise: false
      skip_forgery_protection
    end
  end
end
