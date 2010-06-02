Feature: Exercise Set Recommendation
	
	So I can be challenged and increase my programming interview skills
	As a user
	I want to know what exercises will fairly challenge me
	
	Scenario: A newly registered user gets recommended exercise sets
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics2" with "ex1" and "ex2"
		And I am on my home page
		Then I should see a list of randomly recommended exercise sets
		And I should see "Hey there frank! To start things off here are some sample exercise sets you can try out!"
		
	Scenario: Exercise sets display their statistics
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics" with "ex1" and "ex2"
		And "ex1" has the grades "[90 91]"
		And I am on my home page
		Then I should see exercise "Ex1" with "90.5"
		
	Scenario: A user follows a recommended exercise set
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics" with "ex1" and "ex2"
		And I am on my home page
		When I follow "ex1"
		And I should see "Start Exercise"
		
	Scenario: A user follows an exercise in a recommended exercise set
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics" with "ex1" and "ex2"
		And I am on my home page
		And I follow "ex1"
		And I follow "Start Exercise"
		Then I should see "Are you sure you want to do this"
		And I should see "Bring It On!"
		
		
		

		
		
		