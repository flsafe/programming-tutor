Feature: Browse Exercise Sets

	So I can find an exercise set that will be fun for me
	As a user
	I want to browse exercise sets

	Scenario: The user sees the exercise set titles
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics" with "Ex1" and "Ex2"
		And I am on the exercise sets page
		Then I should see "Linked List Basics"
		
	Scenario: The user clicks on an exercise set to see more info
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics" with "Ex1" and "Ex2"
		And I am on the exercise sets page
		When I follow "Linked List Basics"
		Then I should see "Ex1"
		And I should see "Ex2"

	Scenario Outline: The user sees exercise set statistics
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics" with "Ex1" and "Ex2"
		And <given>
		And I am on the exercise sets page
		Then I should see <should_see>
		
	Examples:
		| given                                                          | should_see |
		| "40" users have done "Linked List Basics"                      | "40"       |
		| "Linked List Basics" has an average grade of "61.34"           | "61.34"    |
		| I have finished "Linked List Basics" with an average of "91.1" | "91.1"     |
		










