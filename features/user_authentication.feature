Feature: User Authentication
	
	So I can start increasing my programming interview skills
	As a user
	I want to login
	
	@valid-credentials
	Scenario: The user provides the proper credentials
		Given I am the registered user "frank"
		And I am on the login page
		When I fill in "Username" with "frank"
		And I fill in "Password" with "password"
		And I press "Submit"
		Then I should be on my home page
		
	Scenario: The user creates an account
		Given I am on the home page
		When I follow "Pricing and Sign Up"
		And I fill in "Username" with "frank"
		And I fill in "Email" with "frank@mail.com"
		And I fill in "Password" with "password"
		And I fill in "Password confirmation" with "password"
		And I press "Create"
		Then I should be on my home page




		
		
		