Feature: Create Exercise Set
	In order to provide my customers with new learning content
	As an admin
	I want to add a new exercise set to the database
	#TODO: Integrate selenium to support javascript in add hint, add unit test, add figure
	
	Scenario: The admin creates a new exercise
		Given I am logged in as the user "frank"
		And I have admin privileges
		When I go to the create exercise page
		And I fill in "Title" with "Implementing a singly linked list"
		And I fill in "Description" with "Implement a singly linked list is a common problem"
		And I fill in "Algorithm list" with "numeric, primes"
		And I fill in "Data structure list" with "linked lists"
		And I fill in "Problem" with "Implementing the add function given a linked list pointer"
		And I fill in "Tutorial" with "There are several ways to implement"
		And I fill in "Hint" with "This is hint 1"
		And I select "60" from "minutes"
		And I attach the file "linkedlist.png" to "Figure"
		And I attach the file "main.c" to "Upload unit test"
		And I create a new exercise set named "Basics" with tags "Linked lists"
		And I insert "Implementing a singly linked list" into the exercise set "Basics"
		And I press "Save"
		And when I go to the exercise set index page
		Then I should see a new exercise set "Basics" in the exercise set index view
		