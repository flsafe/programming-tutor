Before do
end

Before('@start_delayed_job') do
  `script/delayed_job start`
end

After('@start_delayed_job') do
  `script/delayed_job stop`
end
