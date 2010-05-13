Feature: Browse Exercise Sets

	So I can find an exercise set that will be fun for me
	As a user
	I want to browse exercise sets

	Scenario: The users sees the exercise set titles
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics" with "Ex1" and "Ex2"
		And I am on the exercise sets page
		Then I should see "Linked List Basics"
		
	Scenario: The user sees the number of users who completed the exercise set
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics" with "Ex1" and "Ex2"
		And "40" users have done "Linked List Basics"
		And I am on the exercise sets page
		Then I should see "40"
		
	Scenario: The user sees the average grade for the exercise set
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics" with "Ex1" and "Ex2"
		And "Linked List Basics" has an average grade of "61.34"
		And I am on the exercise sets page
		Then I should see "61.34"

		
		
		










