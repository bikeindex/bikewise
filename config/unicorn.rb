if ENV["RAILS_ENV"] == "development"
  working_directory Rails.root
  stderr_path File.join(Rails.root, 'tmp', 'stder.log')
  stdout_path File.join(Rails.root, 'tmp', 'stdout.log')
  worker_processes 2
else  
  working_directory "#{ENV['STACK_PATH']}"
  stderr_path "#{ENV['STACK_PATH']}/log/unicorn.stderr.log"
  stdout_path "#{ENV['STACK_PATH']}/log/unicorn.stdout.log"
  worker_processes 3
end

listen "/tmp/web_server.sock", :backlog => 64

timeout 30

pid '/tmp/web_server.pid'

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

check_client_connection false

before_fork do |server, worker|
  if defined? ActiveRecord::Base
    ActiveRecord::Base.connection.disconnect!
  end
  old_pid = '/tmp/web_server.pid.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
  # defined?(ActiveRecord::Base) and
  #   ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|  
  # if defined?(ActiveRecord::Base)
  #   config = ActiveRecord::Base.configurations[Rails.env] ||
  #       Rails.application.config.database_configuration[Rails.env]
  #   config['reaping_frequency'] = ENV['DB_REAP_FREQ'] || 10 # seconds
  #   config['pool']            =   ENV['DB_POOL'] || 2
  #   ActiveRecord::Base.establish_connection(config)
  # end
  ActiveRecord::Base.establish_connection
  File.write "/proc/#{Process.pid}/oom_adj", '12'
end