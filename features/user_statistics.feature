Feature: Track My Stats
	
	So that I can track my progress
	As a user
	I want to see my usage statistics
	
	Scenario: The user sees how many exercises they've completed
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics" with "Ex1" and "Ex2"
		And I have finished "Ex1" with a "90"
		And I have finished "Ex2" with a "90"
		And I am on my home page
		Then I should see "2" within ".user-statistics"
	
	Scenario: The user sees how much time they've spent solving exercises
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics" with "Ex1" and "Ex2"
		And I have finished "Ex1" with a "90" in "30" minutes
		And I have finished "Ex2" with a "90" in "30" minutes
		And I am on my home page
		Then I should see "1" within ".user-statistics"
