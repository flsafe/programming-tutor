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
    SetGradeSheet.create! :grade=>100, :user=>user, :exercise_set=>exercise_set
  end
end

Given /^"([^\"]*)" has an average grade of "([^\"]*)"$/ do |title, avg_grade|
  exercise_set = ExerciseSet.find_by_title title
  exercise_set.average_grade = avg_grade
  exercise_set.save
end

Given /^I have finished "([^\"]*)" with an average of "([^\"]*)"$/ do |title, avg_grade|
  exercise_set = ExerciseSet.find_by_title title
  
  grade_sheet = SetGradeSheet.new
  grade_sheet.user = @current_user
  grade_sheet.exercise_set = exercise_set
  grade_sheet.grade = avg_grade
  grade_sheet.save
  
  exercise_set.set_grade_sheets << grade_sheet
end

#------------------Exercise Givens--------------------

Given /^I have finished "([^\"]*)" with a "([^\"]*)"$/ do |title, grade|
  exercise = Exercise.find_by_title title
  exercise.grade_sheets.create! :grade=>grade.to_f, :user=>@current_user, :exercise=>exercise
end

Given /^"([^\"]*)" has the grades "([^\"]*)"$/ do |exercise_title, grades|
  exercise = Exercise.find_by_title exercise_title
  grades = grades.split.collect {|g| g.to_f}
  0.upto(grades.count - 1) do |n|
    user = User.create! :username=>"user#{n}", :password=>"password", :password_confirmation=>'password', :email=>"user#{n}@mail.com"
    exercise.grade_sheets.create! :grade=>grades[n], :user=>user, :exercise=>exercise
  end
end

#------------------Exercise Set Whens----------------
When /^I view exercise set "([^\"]*)"$/ do |title|
  exercise_set = ExerciseSet.find_by_title title
  visit exercise_set_url(exercise_set)
end

#------------------Gradeable Then-------------------

Then /^I should see exercise set "([^\"]*)" with "([^\"]*)"$/ do |title, text|
  response.should have_selector ".exercise_set", :content=>title do |exercise_set|
    exercise_set.should contain text
  end
end

Then /^I should see exercise "([^\"]*)" with "([^\"]*)"$/ do |title, text|
  response.should have_selector ".exercise", :content=>title do |exercise_set|
    exercise_set.should contain text
  end
end