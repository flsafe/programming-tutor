Given /^I have finished "([^\"]*)" with a "([^\"]*)"$/ do |title, grade|
  exercise = Exercise.find_by_title title
  exercise.grade_sheets.create! :grade=>grade.to_f, :user=>@current_user, :gradeable=>exercise
end

