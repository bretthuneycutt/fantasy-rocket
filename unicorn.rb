worker_processes 3
timeout 25
preload_app true

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
end

after_fork do |server, worker|
  # Reopen all connections
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection($DB_SETTINGS)
  end
end
