Feature: Do exercise
	So that I can increase my interview skills
	As a user
	I want to write the code to my solution
	
	@javascript
	Scenario: The user performs a syntax check
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics" with "Pointer intro" and "Ex2"
		And I am on the exercise sets page
		When I follow "Linked List Basics"
		And I follow "Pointer intro"
		And I follow "Bring It On!"
		And I fill in the text editor with a sample solution containing a syntax error
		And I press "Check Syntax"
		Then I should see "syntax error" within "#syntax"
		#Then I should see my code todo: This isn't working since the code is in an iframe