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

When /^I view exercise set "([^\"]*)"$/ do |title|
  exercise_set = ExerciseSet.find_by_title title
  visit exercise_set_url(exercise_set)
end

Then /^I should see exercise set "([^\"]*)" with "([^\"]*)"$/ do |title, text|
  response.should have_selector ".exercise_set", :content=>title do |exercise_set|
    exercise_set.should contain text
  end
end