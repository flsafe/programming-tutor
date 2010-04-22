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

Then /^I should see exercise "([^\"]*)" with "([^\"]*)"$/ do |title, text|
  response.should have_selector ".exercise", :content=>title do |exercise_set|
    exercise_set.should contain text
  end
end