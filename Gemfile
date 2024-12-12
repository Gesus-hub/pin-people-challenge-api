# frozen_string_literal: true

source 'https://rubygems.org'

# Rails standard gems
gem 'bootsnap', require: false
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.2.2'
gem 'tzinfo-data', platforms: %i[windows jruby]

# Database
gem 'pg', '~> 1.1'
gem 'strong_migrations', '~> 2.0.0'

# Tools
gem 'activerecord-import', '~> 1.4.0'
gem 'bcrypt', '~> 3.1.20'
gem 'discard', '~> 1.4.0'
gem 'jwt', '~> 2.9.3'
gem 'rswag-api', '~> 2.16.0'
gem 'rswag-ui',    '~> 2.16.0'

group :development do
  gem 'annotate', '~> 3.2.0'
  gem 'letter_opener', '~> 1.10.0'
  gem 'rubocop', '~> 1.68.0', require: false
  gem 'rubocop-factory_bot', '~> 2.26.1', require: false
  gem 'rubocop-performance', '~> 1.23.0', require: false
  gem 'rubocop-rails', '~> 2.27.0', require: false
  gem 'rubocop-rspec', '~> 3.2.0', require: false
  gem 'rubocop-rspec_rails', '~> 2.30.0', require: false
  gem 'spring', '~> 4.2.1'
  gem 'spring-commands-rspec'
  gem 'web-console'
end

group :development, :test do
  gem 'brakeman', require: false
  gem 'database_cleaner', '~> 2.1.0'
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'dotenv-rails', '~> 3.1.5'
  gem 'factory_bot_rails', '~> 6.4.3'
  gem 'faker', '~> 3.4.2'
  gem 'pry-byebug', '~> 3.10'
  gem 'pry-rails', '~> 0.3.11'
  gem 'rspec-rails', '~> 7.0.1'
  gem 'rswag-specs',           '~> 2.16.0'
  gem 'rubocop-rails-omakase', require: false
  gem 'shoulda-matchers', '~> 6.4.0', require: false
end
