Given /^I have finished "([^\"]*)" with a "([^\"]*)"$/ do |title, grade|
  ta = TeachersAid.new
  exercise = Exercise.find_by_title title
  ta.record_grade(Factory.build :grade_sheet, :user=>@current_user, :exercise=>exercise, :grade=>grade)
end

Given /^I have finished "([^\"]*)" with a "([^\"]*)" in "([^\"]*)" minutes$/ do |title, grade, minutes|
  ta = TeachersAid.new
  exercise = Exercise.find_by_title title
  ta.record_grade(Factory.build :grade_sheet, :user=>@current_user, :exercise=>exercise, :grade=>grade, :minutes=>minutes)
end

Given /^"([^\"]*)" has the grades "([^\"]*)"$/ do |exercise_title, grades|
  exercise = Exercise.find_by_title exercise_title
  ta = TeachersAid.new
  grades   = grades.split.collect {|g| g.to_f}
  0.upto(grades.count - 1) do |n|
    ta.record_grade(Factory.create :grade_sheet, :exercise=>exercise, :grade=>grades[n])
  end
end

Given /^the exercise "([^\"]*)" has the solution template "([^\"]*)" and the unit test "([^\"]*)"$/ do |exercise_title, template, unit_test|
  f = File.open("content/#{template}", 'r')
  template = f.read
  f.close
  
  f = File.open("content/#{unit_test}", 'r')
  unit_test = f.read
  f.close
  
  exercise = Exercise.find_by_title exercise_title
  exercise.solution_templates.create! :src_code=>template, :src_language=>'c'
  exercise.unit_tests.create! :src_code=>unit_test, :src_language=>'rb'
end

Given /^the exercise "([^\"]*)" takes "([^\"]*)" minutes to complete$/ do |exercise_title, minutes|
  exercise = Exercise.find_by_title exercise_title
  exercise.minutes = minutes.to_i
  exercise.save
end

When /^I view exercise "([^\"]*)"$/ do |title|
  exercise = Exercise.find_by_title title
  visit exercise_path(exercise)
end

Then /^I should see exercise "([^\"]*)" with "([^\"]*)"$/ do |title, text|
  page.should have_css ".completed-exercise", :content=>title do |exercise_set|
    exercise_set.should have_css ".grade" do |grade|
      grade.should have_content text
    end
  end
end