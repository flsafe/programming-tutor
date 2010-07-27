Feature: Do exercise
	So that I can increase my interview skills
	As a user
	I want to write the code to my solution
		
	Scenario: The user sees the prototype for the exercise they need to complete
		Given I am logged in as the user "frank"
		And there exists an exercise set "String Manipulation" with "RemoveChar" and "Ex2"
		And the exercise "RemoveChar" has the solution template "remove-letter.c" and the unit test "remove-letter-unit-test.rb"
		And I am viewing the tutor page for "RemoveChar"
		Then the "textarea_1" field within "#editor" should contain "void remove_char\(char c, char str\[\]\)"
	
	@javascript
	Scenario: The user sees a timer representing the amount of time they have to complete the exercise
		Given I am logged in as the user "frank"
		And there exists an exercise set "String Manipulation" with "RemoveChar" and "Ex2"
		And the exercise "RemoveChar" has the solution template "remove-letter.c" and the unit test "remove-letter-unit-test.rb"
		And the exercise "RemoveChar" takes "60" minutes to complete
		And I am viewing the tutor page for "RemoveChar"
		Then I should see /59:\d\d/
		
	@javascript
	Scenario: The user is redirected to the incomplete page
		Given I am logged in as the user "frank"
		And there exists an exercise set "String Manipulation" with "RemoveChar" and "Ex2"
		And the exercise "RemoveChar" has the solution template "remove-letter.c" and the unit test "remove-letter-unit-test.rb"
		And the exercise "RemoveChar" takes "0" minutes to complete
		And I am viewing the tutor page for "RemoveChar"
		Then I should see "You didn't finish on time!"
			
	@javascript
	Scenario Outline: The user performs a syntax check
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics" with "Pointer intro" and "Ex2"
		And I am viewing the tutor page for "Pointer intro"
		When I fill in the text editor with <code>
		And I press "Check Syntax"
		Then I should see "checking..."
		And The task is finished
		And I should see <message> within "#message"
		
	Examples:
		| code                           | message                     |
		| "int main(){int i; return 0;}" | "No syntax errors detected" |
		| "int main(){int i return 0;}"  | "syntax error"              | 
		
	@javascript
	Scenario: The user submits a solution to an exercise and it gets graded
		Given I am logged in as the user "frank"
		And there exists an exercise set "String Manipulation" with "RemoveChar" and "Ex2"
		And the exercise "RemoveChar" has the solution template "remove-letter.c" and the unit test "remove-letter-unit-test.rb"
		And I am viewing the tutor page for "RemoveChar"
		When I fill in the text editor with the solution "remove-letter-solution.c"
		And I press "Submit"
		Then I should see "grading..."
		And The task is finished
		And I should see "Remove all letters:" within "#grade_sheet"
		And I should see "Final Grade: 100" within "#grade_sheet"

	@javascript
	Scenario: The user submits a solution to an exercise, but the solution template crashes
		Given I am logged in as the user "frank"
		And there exists an exercise set "String Manipulation" with "RemoveChar" and "Ex2"
		And the exercise "RemoveChar" has the solution template "crap.c" and the unit test "remove-letter-unit-test.rb"
		And I am viewing the tutor page for "RemoveChar"
		When I fill in the text editor with the solution "remove-letter-solution.c"
		And I press "Submit"
		Then I should see "grading..."
		And The task is finished
		And I should see "Error"
			