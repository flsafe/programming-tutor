
Feature: Beta Invite 
	
  So that I can sign up to use Blueberry Tree
  As a user
  I want to request a beta invite

	Scenario: User requests a beta invite 
    Given I am on the home page
    When I follow "Pricing and Sign Up" 
		When I fill in "Email" with "test-user@mail.com" 
    And I press "beta_invite_submit"
    Then there should be a new invite for "test-user@mail.com" 
    And an email should be sent out to "test-user@mail.com" containing the invite link

  Scenario: User registers with the invite link 
    Given there exists an invite for "test-user"
    When I follow the test invite link
    And I fill in "Username" with "test-user"
    And I fill in "Password" with "password"
    And I fill in "Password confirmation" with "password"
    And I press "Submit"
    Then there should be a new user "test-user" in the database
   
  Scenario: User tries to signup without an invite
    Given I haven't requested an invite
    When I navigate to the register page
    Then I should be redirected to the "beta invite" page

  Scenario: User tries to reuse a beta invite
    Given there exists an invite for "test-user"
    And the user "test-user" registers using the invite link
    When a new user tries to use the same invite link
    Then there should be no new user in the database 
