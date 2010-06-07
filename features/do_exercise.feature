Feature: Do exercise
	So that I can increase my interview skills
	As a user
	I want to write the code to my solution
		
	@javascript
	@start_delayed_job
	Scenario Outline: The user performs a syntax check
		Given I am logged in as the user "frank"
		And there exists an exercise set "Linked List Basics" with "Pointer intro" and "Ex2"
		And I am viewing the tutor page for "Pointer intro"
		When I fill in the text editor with <code>
		And I press "Check Syntax"
		Then I should see <message> within "#syntax"
		
	Examples:
		| code                           | message                     |
		| "int main(){int i; return 0;}" | "No syntax errors detected" |
		| "int main(){int i return 0;}"  | "syntax error"              | 
		
		
	@javascript
	@start_delayed_job
	Scenario: The user submits a solution
		Given I am logged in as the user "frank"
		And there exists an exercise set "String Manipulation" with "RemoveChar" and "Ex2"
		And the exercise "RemoveChar" has the associated solution template and unit test
		And I am viewing the tutor page for "RemoveChar"
		When I fill in the text editor with "void do_remove_char(char remove_char, char str[]){int write_index = 0; int read_index  = 0; char curr_char; do{ curr_char = str[read_index]; if(curr_char != remove_char){ str[write_index] = str[read_index]; write_index++;} read_index++; }while(curr_char);}"
		And I press "Submit"
		Then I should see "Grade: 100" within "#grade_sheet"
			
			
			
			