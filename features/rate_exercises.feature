
Feature: Rate Exercises
  So that I can be challenged fairly on the subsequent exercises that I do
	As a user
  I want to rate the exercises on how they challenged me
		
	@javascript
	Scenario: The user sees a rating box after they submit an exercise
    Given I am doing the exercise RemoveChar
		When I press "Submit"
    Then I should see "How did you find this exercise?" 
    And I should see "Too Hard"
    And I should see "Too Easy"
    And I should see "Good Challenge"

	@javascript
	Scenario Outline: The user rates an exercise after completing an exercise 
    Given I am doing the exercise RemoveChar
		When I press "Submit"
    And I follow <rate-option>
    Then The exercise "RemoveChar" is rated <rating>

  Examples:
      | rate-option      | rating           |
      | "Too Hard"       |"too-hard"        | 
      | "Too Easy"       | "too-easy"       | 
      | "Good Challenge" | "good-challenge" | 
