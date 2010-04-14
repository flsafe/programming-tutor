Feature: Exercise Set Recomendation
	
	So I can be challenged and increase my programming interview skills
	As a student
	I want to know what exercises will fairly challenge me
	
	@new-student
	Scenario: A newly registered user gets recommended four random exercise sets
		Given I am a newly registered user with username "Frank"
		And I am on MyHomePage
		Then I should see a list of randomly recommended exercise sets
		And I should see a message that reads "Hey there Frank! To start things off here is are some exercise sets you can try out." 

		
		
		