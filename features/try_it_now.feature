Feature: Try it now
	
	So that I can determine if I want to invest time in signing up
	As a user
	I want to try this app out without filling out any stupid forms

Scenario: The user does an exercise
		Given there exists an exercise set "String Manipulation" with "RemoveChar" and "Ex2"
		And the exercise "RemoveChar" has the solution template "remove-letter.c" and the unit test "remove-letter-unit-test.rb"
		And the exercises "RemoveChar" are the demo exercises
		And I am on the home page
		When I follow "try-it-button"
		And I follow "RemoveChar"
		And I fill in the text editor with the solution "remove-letter-solution.c"
		And I press "Submit"
		And The task is finished
		Then I should see "Remove all letters:" within ".gradesheet"
		And I should see "Final Grade: 100" within ".gradesheet"