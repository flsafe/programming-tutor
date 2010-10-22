
Feature: Rate Exercises
  So that I can be challenged fairly on the subsequent exercises that I do
	As a user
  I want to rate the exercises on how they challenged me
		
	@javascript
	Scenario: The user rates an exercise after completing an exercise 
		Given I am logged in as the user "frank"
		And there exists an exercise set "String Manipulation" with "RemoveChar" and "Ex2"
		And the exercise "RemoveChar" has the solution template "remove-letter.c" and the unit test "remove-letter-unit-test.rb"
		And I am viewing the tutor page for "RemoveChar"
		When I fill in the text editor with the solution "remove-letter-solution.c"
		And I press "Submit"
    And I should see "How did you find this exercise?" 
    And I should see "Too Hard"
    And I follow "Too Hard" 
		And The task is finished
    Then The exercise "RemoveChar" is rated "too-hard"
