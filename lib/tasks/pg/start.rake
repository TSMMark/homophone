namespace :pg do
  desc "development environment: start the pg server and specify logfile"

  task :start do
    puts "Attempting to start postgres server..."
    puts %x[pg_ctl -D /usr/local/var/postgres -l #{Rails.root}/log/pg.log start]
  end

end
