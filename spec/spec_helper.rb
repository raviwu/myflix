# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/email/rspec'
require 'sidekiq/testing'
require 'vcr'

Sidekiq::Testing.inline!

Capybara.server_port = 52662
Capybara.javascript_driver = :webkit
Capybara.default_max_wait_time = 5

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.infer_spec_type_from_file_location!
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.before(:each) do |example|
    Sidekiq::Worker.clear_all
    ActionMailer::Base.deliveries.clear
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
  config.before(:each, elasticsearch: true) do
    Video.__elasticsearch__.create_index! force: true
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

VCR.configure do |config|
  config.cassette_library_dir     = 'spec/cassettes'
  config.hook_into                :webmock
  config.configure_rspec_metadata!
  config.ignore_localhost = true
end

Capybara::Webkit.configure do |config|
  config.allow_url("js.stripe.com")
  config.allow_url("api.stripe.com")
  config.allow_url("q.stripe.com")
  config.block_unknown_urls
end
