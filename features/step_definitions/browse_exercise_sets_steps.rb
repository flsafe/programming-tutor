
Then /^I should see "([^\"]*)" with "([^\"]*)"$/ do |title, text|
  response.should have_selector ".exercise_set", :content=>title do |exercise_set|
    exercise_set.should contain text
  end
end
