source "https://rubygems.org"

ruby "3.2.2"

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
gem 'sorcery', '~> 0.18.0'

# Form
gem 'simple_form'

# Others
gem 'draper'
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "dotenv-rails"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
