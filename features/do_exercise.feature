Feature: Do exercise
	So that I can increase my interview skills
	As a user
	I want to write the code to my solution
	
	Scenario: The user performs a syntax check
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics" with "Pointer intro" and "Ex2"
		And I am viewing the tutor page for "Pointer intro"
		When I fill in the text editor with a sample solution containing a syntax error
		And I press "Syntax Check"
		Then I should see "Syntax Error"