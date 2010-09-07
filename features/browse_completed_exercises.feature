Feature: Browse Completed Exercises

	So that I can review all the exercises I've completed and track my progress
	As a user
	I want to view the exercises I've completed and the grades I got

	Scenario: The user sees the titles of the exercises they've completed
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics" with "Ex1" and "Ex2"
		And I have finished "Ex1" with a "90"
		And I have finished "Ex2" with a "90"
		And I am on my exercises page
		Then I should see "Ex1"
		And I should see "Ex2"

	Scenario: Exercises should show my grade
		Given I am logged in as the user "frank"
		And there exists an exercise set "Basics" with "basics 1" and "basics 2"
		And I have finished "basics 1" with a "91.1"
		When I am on my exercises page
		And I follow "Gradesheet"
		Then I should see "91.1" within ".gradesheet"
		
	Scenario: Exercises show the user average grade for the exercise
	  Given I am logged in as the user "frank"
		And there exists an exercise set "Basics" with "basics 1" and "basics 2"
		And I have finished "basics 1" with a "90"
		And "basics 1" has the grades "91 92"
		When I am on my exercises page
		And I follow "Gradesheet"
		Then I should see "91" within ".exercise-statistics"
		
	Scenario: The user reviews the grade sheet for an exercise they completed
		Given I am logged in as the user "frank"
		And there exists an exercise set "Basics" with "basics 1" and "basics 2"
		And I have finished "basics 1" with a "90" in "15" minutes
		When I am on my exercises page
		And I follow "Gradesheet"
		Then I should see "90" within ".gradesheet"
		And I should see "15" within ".gradesheet"
		
	Scenario: The user reviews the gradesheets that belong to the other users
		Given I am logged in as the user "frank"
		And there exists an exercise set "Basics" with "basics 1" and "basics 2"
		And I have finished "basics 1" with a "80"
		And "basics 1" has the grades "91 92 93"
		When I am on my exercises page
		And I follow "All Gradesheets"
		Then I should see "91" within ".all-grade-sheets"
		Then I should see "92" within ".all-grade-sheets"
		Then I should see "93" within ".all-grade-sheets"







