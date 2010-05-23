Feature: Do exercise
	So that I can increase my interview skills
	As a user
	I want to write the code to my solution
		
	@javascript
	@start_delayed_job
	Scenario Outline: The use performs a syntax check
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics" with "Pointer intro" and "Ex2"
		And I am viewing the tutor page for "Pointer intro"
		And I fill in the text editor with <code>
		And I press "Check Syntax"
		Then I should see <message> within "#syntax"
		
	Examples:
		| code                           | message                     |
		| "int main(){int i; return 0;}" | "No syntax errors detected" |
		| "int main(){int i return 0;}"  | "syntax error"              | 