source "https://rubygems.org"

ruby "3.3.5"

# Core
gem "rails", "~> 8.1.2"
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
gem "rails-i18n", "~> 8.1"
gem "slim-rails"

# Authentication
gem "sorcery", "~> 0.18.0"
gem "omniauth"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"

# Form
gem "simple_form"

# Search
gem "ransack", ">= 4.1"

# Image
gem "activestorage-cloudinary-service"
gem "cloudinary"
gem "image_processing", "~> 1.0"

# Pagination
gem "kaminari"

# Security
gem "rack-attack"

# Others
gem "draper"
gem "enum_help", "0.0.19"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

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
