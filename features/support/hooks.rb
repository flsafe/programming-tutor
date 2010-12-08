Before ('@no-txn') do
  DatabaseCleaner.start
end

After ('@no-txn') do
  DatabaseCleaner.clean
end

Before('@with-rec-engine') do
  out = `env RAILS_ENV=#{Rails.env} recomendation-engine/start`
  puts out
end

After ('@with-rec-engine') do
  `recomendation-engine/stop`
end

  
Before('@with-bg-job') do
  system "/usr/bin/env RAILS_ENV=cucumber script/delayed_job start"
end

After('@with-bg-job') do
  system "user/bin/env RAILS_ENV=cucumber script/delayed_job stop"
end
