Feature: Navigation
	So that I can tell at a glance where I am on the website
	As a user
	I want to navigate using navigation menu
	
	Scenario: My home page should display the navigation menu
		Given I am logged in as the user "frank"
		And I am on my home page
		Then I should see the navigation menu

		
	Scenario: The home page should not show the navigation menu
		Given I am logged in as the user "frank"
		And I am on the home page
		Then I should not see the navigation menu