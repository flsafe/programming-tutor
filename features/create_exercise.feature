Feature: Create Exercise
	In order to provide my customers with new learning content
	As an admin
	I want to add a new exercise to the database
  
	Scenario: The admin creates a new exercise
		Given I am logged in as the user "frank"
		And I have admin privileges
    When I fill in the sample exercise
    And I press "Save"
		Then I should see "Exercise was successfully created."

  Scenario: The admin loads an exercise from the database
    Given I am logged in as the user "frank"
    And I have admin privileges
    When I fill in the sample exercise
    And I press "Save"
    And I am editing the exercise "sample title"
    Then I should see the sample exercise

  Scenario: The admin saves the update form with no exercise
    Given I am logged in as the user "frank"
    And I have admin privileges
    When I fill in the sample exercise
    And I press "Save"
    And I am editing the exercise "sample title"
    And I press "Save changes"
    And I am editing the exercise "sample title"
    And I press "Save changes"
    And I am editing the exercise "sample title"
    Then I should see the sample exercise
