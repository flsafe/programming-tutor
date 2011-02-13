Given /^I am doing the exercise RemoveChar$/ do
  steps %Q{
		Given there exists an exercise set "String Manipulation" with "RemoveChar"
		And the exercise "RemoveChar" has the solution template "remove-letter.c" and the unit test "remove-letter-unit-test.rb"
		And I am logged in as the user "frank"
		And I am viewing the tutor page for "RemoveChar"
		And I fill in the text editor with the solution "remove-letter-solution.c"
  }
end

Given /^I have filled in the exercise "([^"]*)" with "([^"]*)"$/ do |title, solution_file|
  title_t = title.gsub(/\s+/,'').underscore

  solution_template = File.join(title_t, 'solution_template.c')
  unit_test = File.join(title_t, 'unit_test.rb')
  solution = File.join(title_t, solution_file)

  steps %Q{
    Given I am logged in as the user "frank"
		And there exists an exercise set "Exercise Set" with "#{title}" and "Ex2"
		And the exercise "#{title}" has the solution template "#{solution_template}" and the unit test "#{unit_test}"
		And I am viewing the tutor page for "#{title}"
		And I fill in the text editor with the solution "#{solution}"
  }
end

When /^I wait for "([^\"]*)" seconds$/ do |secs|
 sleep(secs.to_i)
end
