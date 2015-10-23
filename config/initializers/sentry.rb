require "raven/base"
require "raven/integrations/rails"
require "raven/integrations/delayed_job"

Raven.configure do |config|
  config.dsn = ENV['SENTRY_DSN']
end
