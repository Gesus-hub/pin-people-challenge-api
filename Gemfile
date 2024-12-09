# frozen_string_literal: true

source 'https://rubygems.org'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.2.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '>= 1.4'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'
# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # rspec-rails brings the RSpec testing framework to Ruby on Rails.
  gem 'rspec-rails', '~> 7.0.1'
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'

  # Shim to load environment variables from .env into ENV in development.
  gem 'dotenv-rails', '~> 3.1.4'

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', require: false

  # factory_bot is a fixtures replacement with a straightforward definition syntax
  gem 'factory_bot_rails', '~> 6.4.3'

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem 'rubocop-rails-omakase', require: false
end

group :development do
  # This gem implements the rspec command for Spring.
  gem 'spring-commands-rspec'
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'rubocop', '~> 1.68.0', require: false
  gem 'rubocop-factory_bot', '~> 2.26.1', require: false
  gem 'rubocop-performance', '~> 1.23.0', require: false
  gem 'rubocop-rails', '~> 2.27.0', require: false
  gem 'rubocop-rspec', '~> 3.2.0', require: false
  gem 'rubocop-rspec_rails', '~> 2.30.0', require: false
  gem 'web-console'
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem 'spring', '~> 4.2.1'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
end
