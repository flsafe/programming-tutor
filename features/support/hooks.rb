Before ('@no-txn') do
  DatabaseCleaner.start
end

After ('@no-txn') do
  DatabaseCleaner.clean
end
