Then /^I should see the navigation menu$/ do
  steps %Q{
  	Then I should see "Overview"
		And I should see "Exercises"
		And I should see "Trends"
  }
end

Then /^I should not see the navigation menu$/ do
  steps %Q{
  	Then I should not see "Overview"
		And I should not see "Exercises"
		And I should not see "Trends"
  }
end