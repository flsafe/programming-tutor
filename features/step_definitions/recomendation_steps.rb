
Then /^the recomendation for "([^\"]*)" should be "([^\"]*)"$/ do |username, exercise_title|
  user = User.find_by_username(username)
  exercise = Exercise.find_by_title(exercise_title)

  recomendations = Recomendation.for(user.id)

  has_exercise = recomendations.include? exercise.id
  has_exercise.should == true
end

Given /^there exists a recomendation for "([^\"]*)"$/ do |exercise_titles|
  exercises = Exercise.find :all,
    :conditions=>{:title=>exercise_titles.split},
    :select=>[:id]
  exercise_ids = exercises.map {|e| e.id}.join(',')
  recomended_ids = ExerciseRecomendationList.new(exercise_ids)
  recomended_ids

  rec = Recomendation.new
  rec.user_id = @current_user.id
  rec.exercise_recomendation_list = recomended_ids
  rec.save!
end

