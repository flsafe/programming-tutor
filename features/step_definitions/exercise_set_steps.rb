Given /^there exists an exercise set "([^\"]*)" with "([^\"]*)" and "([^\"]*)"$/ do |set_title, ex1_title, ex2_title|
  ex1 = Exercise.create! :title=>ex1_title, :description=>"#{ex1} description"
  ex2 = Exercise.create :title=>ex2_title, :description=>"#{ex2} description"
  set = ExerciseSet.create! :title=>set_title, :description=>"#{set_title} description", :exercises=>[ex1, ex2]
end

Given /^"([^\"]*)" users have done "([^\"]*)"$/ do |n_users, title|
  exercise_set = ExerciseSet.find_by_title title
  exercise_set.users_completed = n_users
  exercise_set.save
end

Given /^"([^\"]*)" has an average grade of "([^\"]*)"$/ do |title, avg_grade|
  exercise_set = ExerciseSet.find_by_title title
  exercise_set.average_grade = avg_grade
  exercise_set.save
end

Given /^I have finished "([^\"]*)" with an average of "([^\"]*)"$/ do |title, avg_grade|
  exercise_set = ExerciseSet.find_by_title title
  grade_sheet = GradeSheet.new
  grade_sheet.user = @current_user
  grade_sheet.resource = exercise_set
  grade_sheet.grade = avg_grade
  grade_sheet.save
end