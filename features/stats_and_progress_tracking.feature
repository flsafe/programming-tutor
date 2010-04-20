Feature: Stats And Progress Tracking
	So that I know how well I did on the exercises and exercise sets at a glance
	As a user
	I want to browse exercises and exercise sets that track my progress and statistics
	
	Scenario: Exercises should show my grade
		Given I am logged in as the user "frank"
		And there exists an exercise set "Basics" with "basics 1" and "basics 2"
		And I have finished "basics 1" with a "91.1"
		When I view "Basics"
		Then I should see "basics 1" with my grade "91.1"