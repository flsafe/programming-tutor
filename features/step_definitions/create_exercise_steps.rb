
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
      And I fill in "Minutes" with "60"
      And I attach the file "content/remove-letter.c" to "Upload Solution Template"
      And I attach the file "content/remove-letter-unit-test.rb" to "Upload Unit Test"
      And I fill in "Set Title" with "sample exercise set title"
      And I fill in "Set Description" with "sampel exercise set description"
      And I fill in "Set Algorithm Tags" with "sample exercise algorithm" 
      And I fill in "Set Data Structure Tags" with "sample exercise data structure"
      And I fill in "Order In Set" with "1"
    }
end

Then /^I should see the sample exercise$/ do 
  steps %Q{
    Then I should see "Editing exercise"
    And the "Title" field should contain "sample title"
    And the "Description" field should contain "sample description"
    And the "Algorithm list" field should contain "sample algorithm"
    And the "Data structure list" field should contain "sample data structure"
    And the "Problem" field should contain "sample problem"
    And the "Tutorial" field should contain "sample tutorial"
    And the "Hint" field should contain "sample hint"
    And the "Solution Template Lang" field should contain "c"
    And the "Solution Template Code" field should contain "int main"
    And the "Unit Test Lang" field within "#unit_tests" should contain "ruby"
    And the "Unit Test Code" field within "#unit_tests" should contain "def test_all_letters_removed"
  }
end

When /^I am editing the exercise "([^\"]*)"$/ do |title|
  exercise = Exercise.find_by_title title
  visit edit_exercise_path(exercise) 
end

