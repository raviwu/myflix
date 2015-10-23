source 'https://rubygems.org'
ruby '2.1.2'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'bootstrap_form', '2.3.0'
gem 'bcrypt', '~> 3.1.7'
gem 'fabrication'
gem 'faker'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'
gem 'unicorn'

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers', '3.0.0'
  gem 'capybara'
  gem 'capybara-email'
end

group :production, :staging do
  gem 'rails_12factor'
  gem "sentry-raven"
end
