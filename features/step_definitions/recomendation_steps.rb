Given /^the recomendation server is on$/ do 
  out = `env RAILS_ENV=#{Rails.env} recomendation-engine/start`
  puts out
end

Then /^the recomendation for "([^\"]*)" should be "([^\"]*)"$/ do |username, exercise_title|
  user = User.find_by_username(username)
  exercise = Exercise.find_by_title(exercise_title)

  recomendations = Recomendation.for(user.id)

  has_exercise = recomendations.include? exercise.id
  has_exercise.should == true
  recomendations.size.should == 1
end

