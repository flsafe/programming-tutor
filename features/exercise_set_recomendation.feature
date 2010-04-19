Feature: Exercise Set Recommendation
	
	So I can be challenged and increase my programming interview skills
	As a user
	I want to know what exercises will fairly challenge me
	
	Scenario: A newly registered user gets recommended four random exercise sets
		Given I am logged in as the user "frank"
		And I have not done any exercises
		And I am on my home page
		Then I should see a list of randomly recommended exercise sets
		And I should see "Hey there frank! To start things off here are some sample exercise sets you can try out!" 
		
	Scenario: A user follows a recommended exercise set
		Given I am logged in as the user "frank"
		And I am on my home page
		When I follow "Linked List Basics"
		Then I should see "Linked List Basics"
		And I should see ""
		
		
		

		
		
		