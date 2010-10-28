Then /^the recomendation for "([^\"]*)" should be "([^\"]*)"$/ do |username, exercise_title|
  user = User.find_by_username(username)
  exercise = Exercise.find_by_title(exercise_title)

  recomendations = Recomendation.for(user.id)
  has_exercise = recomendations.detect {|ex_id| ex_id == exercise.id}

  puts "*" * 10
  puts recomendations
    
  has_exercise.should == true
  recomendationsize.should == 1
end
