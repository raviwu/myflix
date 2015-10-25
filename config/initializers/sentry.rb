if Rails.env.production?
  require 'raven'
  Raven.configure do |config|
    config.environments = ['production']
    config.dsn = ENV['SENTRY_DSN']
  end
end
