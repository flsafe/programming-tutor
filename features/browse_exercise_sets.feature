Feature: Browse Exercise Sets

	So I can find an exercise set that will be fun
	As a user
	I want to browse exercise sets
	
	Scenario: Browsing the exercise set page
		Given I am logged in as the user "frank"
		And there exists several exercise sets with user activity
		And I am on the exercise set page
		Then I should see a list of the available exercise sets by title
		And I should see the number of users who completed each exercise set
		And I should see the average grade for each exercise set
		And I should see an indication if I completed the exercise set
