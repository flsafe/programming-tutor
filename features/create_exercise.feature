Feature: Create Exercise
	In order to provide my customers with new learning content
	As an admin
	I want to add a new exercise to the database
	
	Scenario: The admin creates a new exercise
		Given I am logged in as the user "frank"
		And I have admin privileges
    When I fill in the sample exercise
		Then I should see "Exercise was successfully created."

  Scenario: The admin loads an exercise from the database
    Given I am logged in as the user "frank"
    And I have admin privileges
    When I fill in the sample exercise
    And I am editing the exercise "sample title"
    Then I should see "Editing exercise"
    And the "Title" field should contain "sample title"
    And the "Description" field should contain "sample description"
    And the "Algorithm list" field should contain "sample algorithm"
    And the "Data structure list" field should contain "sample data structure"
    And the "Problem" field should contain "sample problem"
    And the "Tutorial" field should contain "sample tutorial"
    And the "Hint" field should contain "sample hint"
    And the "Src language" field should contain "c"
    And the "Src code" field should contain "int main"
    And the "Src language" field within "#unit_tests" should contain "rb"
    And the "Src code" field within "#unit_tests" should contain "RemoveLetterUnitTest"
    And the "Image" field within "#figures" should contain "/system/images/*"
    And the "Img link" field within "#figures" should contain "<img alt=.+ src=.+/>"
