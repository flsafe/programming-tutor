
Then /^the exercise "([^\"]*)" is rated "([^\"]*)"$/ do |exercise_title, html_id_rating_name|
  rating_map = {'too-hard'=>1.0, 'too-easy'=> 2.0, 'good-challenge'=>3.0}

  exercise = Exercise.find_by_title(exercise_title)

  user_ratings = Rating.find :all, 
   :conditions=>{:user_id=>@current_user.id,
                 :exercise_id=>exercise.id,
                 :rating=>rating_map[html_id_rating_name]}

  user_ratings.count.should == 1
end

Given /^the user "([^\"]*)" rates "([^\"]*)" as "([^\"]*)"$/ do |username, exercise_title, rating|
  user = User.find_by_username(username)
  exercise = Exercise.find_by_title(exercise_title)
  rating = Rating.to_value(rating)
  Rating.create!(:user_id=>user.id, :exercise_id=>exercise.id, :rating=>rating)
end
