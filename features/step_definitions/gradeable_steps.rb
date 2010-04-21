#----------------Exercise Set Givens--------------

Given /^there exists an exercise set "([^\"]*)" with "([^\"]*)" and "([^\"]*)"$/ do |set_title, ex1_title, ex2_title|
  @ex1 = Exercise.create! :title=>ex1_title, :description=>"#{@ex1} description"
  @ex2 = Exercise.create :title=>ex2_title, :description=>"#{@ex2} description"
  @exercise_set = ExerciseSet.create! :title=>set_title, :description=>"#{set_title} description", :exercises=>[@ex1, @ex2]
end

Given /^"([^\"]*)" users have done "([^\"]*)"$/ do |n_users, title|
  exercise_set = ExerciseSet.find_by_title title
  1.upto(n_users.to_i) do |n|
    user = User.create! :username=>"user#{n}", :password=>"password", :password_confirmation=>'password', :email=>"user#{n}@mail.com"
    GradeSheet.create! :grade=>100, :user=>user, :gradeable=>exercise_set
  end
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
  grade_sheet.gradeable = exercise_set
  grade_sheet.grade = avg_grade
  grade_sheet.save
end

#------------------Exercise Givens--------------------

Given /^I have finished "([^\"]*)" with a "([^\"]*)"$/ do |title, grade|
  exercise = Exercise.find_by_title title
  exercise.grade_sheets.create! :grade=>grade.to_f, :user=>@current_user, :gradeable=>exercise
end

Given /^"([^\"]*)" has the grades "([^\"]*)"$/ do |exercise_title, grades|
  exercise = Exercise.find_by_title exercise_title
  grades = grades.split.collect {|g| g.to_f}
  0.upto(grades.count - 1) do |n|
    user = User.create! :username=>"user#{n}", :password=>"password", :password_confirmation=>'password', :email=>"user#{n}@mail.com"
    exercise.grade_sheets.create! :grade=>grades[n], :user=>user, :gradeable=>exercise
  end
end

#------------------Exercise Set Whens----------------

#--none--

#------------------Exercise Whens-------------------

When /^I view "([^\"]*)"$/ do |title|
  exercise_set = ExerciseSet.find_by_title title
  visit exercise_set_url(exercise_set)
end