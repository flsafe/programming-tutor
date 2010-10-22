
Then /^The exercise "([^\"]*)" is rated "([^\"]*)"$/ do |exercise_title, html_id_rating_name|
  rating_map = {'too-hard'=>1.0, 'too-easy'=> 2.0, 'good-challenge'=>3.0}

  exercise = Exercise.find_by_title(exercise_title)

  user_ratings = Rating.find :all, 
   :conditions=>{:user_id=>@current_user.id,
                 :exercise_id=>exercise.id,
                 :rating=>rating_map[html_id_rating_name]}

  user_ratings.count.should == 1
end
