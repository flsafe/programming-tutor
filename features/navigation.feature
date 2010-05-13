Feature: Navigation
	So that I can tell at a glance where I am on the website
	As a user
	I want to navigate using navigation menu
		
	Scenario Outline: Navigation Visibility
		Given I am logged in as the user "frank"
		And I am on <page>
		Then I <may> see the navigation menu
		
	Examples:
		| page              | may        |
		| my home page      | should     |
		| the home page     | should not |
		| the register page | should not |
		| the login page    | should not |
