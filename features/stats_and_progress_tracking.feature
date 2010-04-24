Feature: Stats And Progress Tracking
	So that I know how well I did on the exercises and exercise sets at a glance
	As a user
	I want to browse exercises and exercise sets that track my progress and statistics
	
	Scenario: Exercises should show my grade
		Given I am logged in as the user "frank"
		And there exists an exercise set "Basics" with "basics 1" and "basics 2"
		And I have finished "basics 1" with a "91.1"
		When I view exercise set "Basics"
		Then I should see exercise "basics 1" with "91.1"
		
	Scenario: Exercises show the user average grade
	  Given I am logged in as the user "frank"
		And there exists an exercise set "Basics" with "basics 1" and "basics 2"
		And "basics 1" has the grades "30 31"
		When I view exercise set "Basics"
		Then I should see exercise "basics 1" with "30.5"

	Scenario: Exercise sets show my grade on the set (average of my exercise sets)
			Given I am logged in as the user "frank"
			And there exists an exercise set "Basics" with "basics 1" and "basics 2"
			And I have finished "basics 1" with a "90"
			And I have finished "basics 2" with a "91"
			When I view exercise set "Basics"
			Then I should see "90.5"