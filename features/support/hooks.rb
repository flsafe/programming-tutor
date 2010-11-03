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
