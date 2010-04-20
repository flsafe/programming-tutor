Feature: Exercise Set Recommendation
	
	So I can be challenged and increase my programming interview skills
	As a user
	I want to know what exercises will fairly challenge me
	
	Scenario: A newly registered user gets recommended exercise sets
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics" with "ex1" and "ex2"
		And I am on my home page
		Then I should see a list of randomly recommended exercise sets
		And I should see "Hey there frank! To start things off here are some sample exercise sets you can try out!" 
		
	Scenario: Exercise sets display their statistics
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics" with "ex1" and "ex1"
		And "10" users have done "Linked List Basics"
		And "Linked List Basics" has an average grade of "91.1"
		And I am on my home page
		Then I should see "Linked List Basics" with "10"
		And I should see "Linked List Basics" with "91.1"
		
	Scenario: Exercise sets indicate when I've completed them
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics" with "ex1" and "ex2"
		And I have finished "Linked List Basics" with an average of "75.1"
		And I am on my home page
		Then I should see "Linked List Basics" with "75.1"
		
	Scenario: A user follows a recommended exercise set
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics" with "ex1" and "ex2"
		And I am on my home page
		When I follow "Linked List Basics"
		Then I should see "ex1"
		And I should see "ex2"
		
	Scenario: A user follows an exercise in a recommended exercise set
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics" with "ex1" and "ex2"
		And I am on my home page
		When I follow "Linked List Basics"
		And I follow "ex1"
		Then I should see "Are you sure you want to do this"
		And I should see "Back"
		And I should see "Bring It On!"
		
		
		

		
		
		