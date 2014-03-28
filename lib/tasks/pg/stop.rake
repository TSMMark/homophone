namespace :pg do
  desc "development environment: stop the pg server"

  task :stop do
    puts "Attempting to stop postgres server..."
    puts "If your rails server is running you'll have to stop it..."
    puts %x[pg_ctl -D /usr/local/var/postgres stop]
  end

end
