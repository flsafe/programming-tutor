



#------------------Exercise Givens--------------------



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