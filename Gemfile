source "https://rubygems.org"

# Command to update gems -> bundle install
# Applications GEMS

# Rails Base GEMS
# Integrate Dart Sass with the asset pipeline in Rails. [https://github.com/rails/dartsass-rails]
gem "dartsass-rails", "0.5.1"
# Object oriented authorization for Rails applications. [https://github.com/varvet/pundit]
gem "pundit", "2.5.2"
# Soft deletes for ActiveRecord done right. [https://github.com/jhawthorn/discard]
gem "discard", "1.4.0"
# Agnostic pagination in plain ruby. It does it all. Better. [https://github.com/ddnexus/pagy]
gem "pagy", "43.3.0"
# Rails default GEMS
gem "rails", "8.1.2"
# Ruby on Rails [https://rubyonrails.org/]
gem "propshaft"
# Use sqlite3 as the database for Active Record
gem "sqlite3", "2.9.0"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "7.2.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"
# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "3.1.21"
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem [https://github.com/tzinfo/tzinfo]
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb [https://github.com/Shopify/bootsnap]
gem "bootsnap", require: false
# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false
# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false
# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # Applications GEMS
  # Rails Base GEMS
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console. [https://github.com/deivid-rodriguez/byebug]
  gem "byebug", "13.0.0"
  # factory_bot is a fixtures replacement with a straightforward definition syntax. [https://github.com/thoughtbot/factory_bot_rails]
  gem "factory_bot_rails", "6.5.1"
  # Faker helps you generate realistic test data. [https://github.com/faker-ruby/faker]
  gem "faker", "3.6.0"
  # Rails default GEMS
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false
  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
  # Process manager for applications with multiple components
  gem "foreman", "0.90.0"
end

group :development do
  # Applications GEMS
  # Rails Base GEMS
  # Rails default GEMS
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :test do
  # Applications GEMS
  # Rails Base GEMS
  # SimpleCov is a code coverage analysis tool for Ruby. [https://github.com/simplecov-ruby/simplecov]
  gem "simplecov", "0.22.0"
  # rspec-rails integrates the Rails testing helpers into RSpec. [https://github.com/rspec/rspec-rails]
  gem "rspec-rails", "8.0.3"
  # Simple one-liner tests for common Rails functionality [https://github.com/thoughtbot/shoulda-matchers]
  gem "shoulda-matchers", "7.0.1"
  # A set of RSpec matchers for testing Pundit policies. [https://github.com/pundit-community/pundit-matchers]
  gem "pundit-matchers", "4.0.0"
  # Adds realtime console.log output to Capybara + Selenium + Chromedriver
  # fork from original project to avoid deprecating warnning
  gem "capybara-chromedriver-logger", git: "https://github.com/Proposito-Digital/capybara-chromedriver-logger"
  # Can be used to ensure a clean slate for testing. [https://github.com/DatabaseCleaner/database_cleaner]
  gem "database_cleaner", "2.1.0"
  # Rails default GEMS
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara", "3.40.0"
  gem "selenium-webdriver", "4.41.0"
end
