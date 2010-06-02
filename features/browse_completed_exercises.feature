Feature: Browse Completed Exercises

	So that I can review all the exercises I've completed
	As a user
	I want to view the exercises I've completed

	Scenario: The user sees the titles of the exercises they've completed
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics" with "Ex1" and "Ex2"
		And I have finished "Ex1" with a "90"
		And I am on my exercises page
		Then I should see "Ex1"










