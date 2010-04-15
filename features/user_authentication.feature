Feature: User Authentication
	
	So I can start increasing my programming interview skills
	As a user
	I want to login
	
	@valid-credentials
	Scenario: The user provides the proper credentials
		Given I am the registered user "frank"
		And I am on the login page
		When I fill in "username" with "frank"
		And I fill in "password" with "password"
		And I press "submit"
		Then I should be on my home page




		
		
		