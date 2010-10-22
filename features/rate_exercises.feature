
Feature: Rate Exercises
  So that I can be challenged fairly on the subsequent exercises that I do
	As a user
  I want to rate the exercises on how they challenged me
		
	@javascript
	Scenario: The user rates an exercise after completing an exercise 
    Given I am doing the exercise RemoveChar
		And I press "Submit"
    And I should see "How did you find this exercise?" 
    And I should see "Too Hard"
    And I follow "Too Hard" 
		And The task is finished
    Then The exercise "RemoveChar" is rated "too-hard"
