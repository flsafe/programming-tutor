Feature: Navigation
	So that I can tell at a glance where I am on the website
	As a user
	I want to navigate using navigation menu
		
	Scenario Outline: Navigation Visibility
		Given I am logged in as the user "frank"
		And I am on <page>
		Then I <may> see the navigation menu
		And I should not see "Admin" within "#menu"
		
	Examples:
		| page              | may        |
		| the home page     | should not |
		| the register page | should not |
		| the login page    | should not |
