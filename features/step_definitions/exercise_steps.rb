Given /^I have finished "([^\"]*)" with a "([^\"]*)"$/ do |title, grade|
  exercise = Exercise.find_by_title title
  exercise.grade_sheets.push(Factory.build :grade_sheet, :user=>@current_user, :exercise=>exercise, :grade=>grade)
end

Given /^"([^\"]*)" has the grades "([^\"]*)"$/ do |exercise_title, grades|
  exercise = Exercise.find_by_title exercise_title
  grades = grades.split.collect {|g| g.to_f}
  0.upto(grades.count - 1) do |n|
    Factory.create :grade_sheet, :exercise=>exercise, :grade=>grades[n]
  end
end

Then /^I should see exercise "([^\"]*)" with "([^\"]*)"$/ do |title, text|
  response.should have_selector ".exercise", :content=>title do |exercise_set|
    exercise_set.should contain text
  end
end