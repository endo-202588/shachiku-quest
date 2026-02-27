source "https://rubygems.org"

ruby "3.2.10"

# Core
gem "rails", "~> 7.2.3"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "bootsnap", require: false

# Frontend
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"

# Views
gem "jbuilder"
gem "rails-i18n", "~> 7.0"
gem "slim-rails"

# Authentication
gem "sorcery", "~> 0.18.0"

# Form
gem "simple_form"

# Search
gem "ransack", ">= 4.1"

# image
gem "image_processing", "~> 1.0"

# Others
gem "draper"
gem "enum_help", "0.0.19"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "kaminari"

group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"

  gem "debug", platforms: %i[ mri mingw mswin x64_mingw ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "dotenv-rails"
end

group :development do
  gem "web-console"
  gem "letter_opener_web"
  gem "whenever", require: false
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
