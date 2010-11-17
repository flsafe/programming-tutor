
When /^I fill in the sample exercise$/ do
		steps %Q{
      When I go to the create exercise page
      And I fill in "Title" with "sample title"
      And I fill in "Description" with "sample description"
      And I fill in "Algorithm list" with "sample algorithm"
      And I fill in "Data structure list" with "sample data structure"
      And I fill in "Problem" with "sample problem"
      And I fill in "Tutorial" with "sample tutorial"
      And I fill in "Hint" with "sample hint"
      And I select "60" from "Minutes"
      And I attach the file "content/test.png" to "Upload Figure"
      And I attach the file "content/remove-letter.c" to "Upload Solution Template"
      And I attach the file "content/remove-letter-unit-test.rb" to "Upload Unit Test"
      And I fill in "Set Title" with "sample exercise set title"
      And I fill in "Set Description" with "sampel exercise set description"
      And I fill in "Set Algorithm Tags" with "sample exercise algorithm" 
      And I fill in "Set Data Structure Tags" with "sample exercise data structure"
      And I attach the file "content/test.png" to "Upload Figure"
      And I press "Save"
    }
end

When /^I am editing the exercise "([^\"]*)"$/ do |title|
  exercise = Exercise.find_by_title title
  visit edit_exercise_path(exercise) 
end

