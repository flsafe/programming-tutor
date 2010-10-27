Then /^the recomendation for "([^\"]*)" should be "([^\"]*)"$/ do |username, exercise_id|
  user = User.find_by_username(username)
  exercise_id = exercise_id.to_i
  recomendations = Recomendation.for(user.id)

  has_exercise = recomendations.detect {|ex_id| exi_id == exercise_id}
    
  has_exercise.should == true
  recomendationsize.should == 1
end
