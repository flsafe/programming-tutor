Given /^the exercises "([^\"]*)" are the demo exercises$/ do |exercises|
  exercise_titles = exercises.split
  APP_CONFIG['demo_exercise_titles'] = exercise_titles
end