Given /^I have finished "([^\"]*)" with a "([^\"]*)"$/ do |title, grade|
  ta = TeachersAid.new
  exercise = Exercise.find_by_title title
  ta.record_grade(Factory.build :grade_sheet, :user=>@current_user, :exercise=>exercise, :grade=>grade)
end

Given /^"([^\"]*)" has the grades "([^\"]*)"$/ do |exercise_title, grades|
  exercise = Exercise.find_by_title exercise_title
  ta = TeachersAid.new
  grades   = grades.split.collect {|g| g.to_f}
  0.upto(grades.count - 1) do |n|
    ta.record_grade(Factory.create :grade_sheet, :exercise=>exercise, :grade=>grades[n])
  end
end

When /^I view exercise "([^\"]*)"$/ do |title|
  exercise = Exercise.find_by_title title
  visit exercise_path(exercise)
end

Then /^I should see exercise "([^\"]*)" with "([^\"]*)"$/ do |title, text|
  page.should have_css ".exercise", :content=>title do |exercise_set|
    exercise_set.should contain text
  end
end