Then /^I should see "([^\"]*)" with my grade "([^\"]*)"$/ do |title, grade|
  response.should have_selector ".exercise", :content=>title do |exercise|
    exercise.should contain grade
  end
end

Then /^the average grade for "([^\"]*)" should be "([^\"]*)"$/ do |exercise_title, average_grade|
  exercise = Exercise.find_by_title exercise_title
  exercise.average_grade.should == average_grade.to_f
end
