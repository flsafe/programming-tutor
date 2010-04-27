Feature: Create Exercise Set
	In order to provide my customers with new learning content
	As an admin
	I want to add a new exercise set to the database
	
	Scenario: The admin creates a new exercise
		Given I am logged in as the user "frank"
		And I have admin privileges
		When I go to the create exercise page
		And I fill in "Title" with "Implementing a singly linked list"
		And I fill in "Description" with "Implement a singly linked list is a common problem"
		And I fill in "Problem" with "Implementing the add function given a linked list pointer"
		And I fill in "Tutorial" with "There are several ways to implement"
		And I fill in "Tags" with "Linked List, Pointers"
		And I select "60" from "minutes"
		And I attach the file "linkedlist.png" to "Upload new image"
		And I attach the file "pointer.png" to "Upload new image"
		And I attach the file "unittest.c" to "Unit test"
		And I add 3 hints "Hint 1, Hint 2, Hint 3"
		And I create a new exercise set named "Basics" with tags "Linked lists"
		And I insert "Implementing a singly linked list" into the exercise set "Basics"
		And I press "Save"
		And when I go to the exercise set index page
		Then I should see a new exercise set "Basics" in the exercise set index view
		