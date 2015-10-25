run_sidekiq_in_this_thread = %w(staging).include?(ENV['RAILS_ENV'])
worker_processes (run_sidekiq_in_this_thread ? 2 : 3)
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
preload_app true
@sidekiq_pid = nil

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  if run_sidekiq_in_this_thread
    @resque_pid ||= spawn("bundle exec sidekiq -c 2")
    Rails.logger.info('Spawned sidekiq #{@request_pid}')
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
