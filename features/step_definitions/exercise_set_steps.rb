Given /^there exists an exercise set "([^\"]*)" with "([^\"]*)"$/ do |set_title, ex1_title|
  @ex1 = Factory.create :exercise, :title=>ex1_title
  @exercise_set = Factory.create :exercise_set, :title=>set_title, :exercises=>[@ex1]
end

Given /^there exists an exercise set "([^\"]*)" with "([^\"]*)" and "([^\"]*)"$/ do |set_title, ex1_title, ex2_title|
  @ex1 = Factory.create :exercise, :title=>ex1_title
  @ex2 = Factory.create :exercise, :title=>ex2_title
  @exercise_set = Factory.create :exercise_set, :title=>set_title, :exercises=>[@ex1, @ex2]
end

Given /^"([^\"]*)" users have done "([^\"]*)"$/ do |n_users, title|
  exercise_set = ExerciseSet.find_by_title title
  1.upto(n_users.to_i) do |n|
    Factory.create :set_grade_sheet, :exercise_set=>exercise_set
  end
end

Given /^"([^\"]*)" has an average grade of "([^\"]*)"$/ do |title, avg_grade|
  exercise_set = ExerciseSet.find_by_title title
  exercise_set.average_grade = avg_grade
  exercise_set.save
end

Given /^I have finished "([^\"]*)" with an average of "([^\"]*)"$/ do |title, avg_grade|
  exercise_set = ExerciseSet.find_by_title title
  g = Factory.create :set_grade_sheet, :exercise_set=>exercise_set, :grade=>avg_grade, :user=>@current_user
end

When /^I view exercise set "([^\"]*)"$/ do |title|
  exercise_set = ExerciseSet.find_by_title title
  visit exercise_set_url(exercise_set)
end

Then /^I should see exercise set "([^\"]*)" with "([^\"]*)"$/ do |title, text|
  page.should have_css ".exercise_set", :content=>title do |exercise_set|
    exercise_set.should contain text
  end
end
