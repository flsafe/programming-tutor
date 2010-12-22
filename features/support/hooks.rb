Before ('@no-txn') do
  DatabaseCleaner.start
end

After ('@no-txn') do
  DatabaseCleaner.clean
end

Before('@with-rec-engine') do
  out = `env RAILS_ENV=cucumber recomendation-engine/start`
  puts out
end

After ('@with-rec-engine') do
  out = `env RAILS_ENV=cucumber recomendation-engine/stop`
  puts out
end

Before('@with-bg-job') do
  system "/usr/bin/env RAILS_ENV=cucumber script/delayed_job --pid-dir=#{Rails.root}/tmp/pids/cucumber start"
end

After('@with-bg-job') do
  system "/usr/bin/env RAILS_ENV=cucumber script/delayed_job --pid-dir=#{Rails.root}/tmp/pids/cucumber stop"
end
