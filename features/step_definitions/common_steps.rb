Given /^I am doing the exercise RemoveChar$/ do
  steps %Q{
		Given I am logged in as the user "frank"
		And there exists an exercise set "String Manipulation" with "RemoveChar" and "Ex2"
		And the exercise "RemoveChar" has the solution template "remove-letter.c" and the unit test "remove-letter-unit-test.rb"
		And I am viewing the tutor page for "RemoveChar"
		And I fill in the text editor with the solution "remove-letter-solution.c"
  }
end

When /^I wait for "([^\"]*)" seconds$/ do |secs|
 sleep(secs.to_i)
end
