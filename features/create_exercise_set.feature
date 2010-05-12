Feature: Create Exercise Set
	In order to provide my customers with new learning content
	As an admin
	I want to add a new exercise set to the database
	#TODO: Figure out why the 'params' don't work!
	
	@wip
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
		And I attach the file "test.png" to "Figure"
		And I attach the file "unittest.c" to "Upload unit test"
		And I fill in "Set Title" with "Linked List Basics"
		And I fill in "Set Description" with "Implement linked lists"
		And I fill in "Set Algorithm Tags" with "Traverse Linked List"
		And I fill in "Set Data Structure Tags" with "Linked Lists"
		And I press "Save"
		And when I go to the exercise set index page
		Then I should see a new exercise set "Linked List Basics" in the exercise set index view
		 