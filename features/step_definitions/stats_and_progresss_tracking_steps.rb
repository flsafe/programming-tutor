Then /^I should see "([^\"]*)" with my grade "([^\"]*)"$/ do |title, grade|
  response.should have_selector ".exercise", :content=>title do |exercise|
    exercise.should contain grade
  end
end