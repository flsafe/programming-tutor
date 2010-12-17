Feature: Do exercise
	So that I can increase my interview skills
	As a user
	I want to write the code to my solution

  # Notes: 
  #   When the user first logs in the recomended exercise is
  #   dsiplayed. If there is no current recomened exercise
  #   then a recomendation for a random exercise will be created.
  #   This means that there should be some exercise data
  #   in the db before the user logs in otherwise wierd stuff happens.
  #
  #   Blueberry will only show an exercise if it is a recomended exercise
  #   or if it is retake. Therefore make sure one of these is the case
  #   before attempting to show the tutor page for an exercise.
  #
  #   Everything in between double quotes is split into
  #   multiple arguments around white space. For example:
  #
  #   "Remove A Char"      => "Remove" "A" "Char"
  #   "RemoveAChar Primes" => "RemoveAChar Primes"
		
	Scenario: The user sees the prototype for the exercise they need to complete
		Given there exists an exercise set "String Manipulation" with "RemoveChar" and "Ex2"
		And the exercise "RemoveChar" has the solution template "remove-letter.c" and the unit test "remove-letter-unit-test.rb"
		And I am logged in as the user "frank"
		When I am viewing the tutor page for "RemoveChar"
		Then the "textarea_1" field within "#editor" should contain "void remove_char\(char c, char str\[\]\)"

	Scenario: The user can't do another exercise after they've started one
		Given there exists an exercise set "String Manipulation" with "RemoveChar" and "Ex2"
		And the exercise "RemoveChar" has the solution template "remove-letter.c" and the unit test "remove-letter-unit-test.rb"
		And I am logged in as the user "frank"
		And the exercise "RemoveChar" takes "60" minutes to complete
		And I am viewing the tutor page for "RemoveChar"
		When I am viewing the tutor page for "Ex2"	
		Then I should see "You are already doing an exercise!"
	
	@javascript
	Scenario: The user sees a timer representing the amount of time they have to complete the exercise
		Given there exists an exercise set "String Manipulation" with "RemoveChar" and "Ex2"
		And the exercise "RemoveChar" has the solution template "remove-letter.c" and the unit test "remove-letter-unit-test.rb"
		And the exercise "RemoveChar" takes "60" minutes to complete
		And I am logged in as the user "frank"
		When I am viewing the tutor page for "RemoveChar"
		Then I should see /59:\d\d/

  @javascript
  Scenario Outline: The exercise timer is reset after the user completes the exercise
    Given I am doing the exercise RemoveChar
    When I press <button>
    And The task is finished
    And I wait for "5" seconds
    And I am viewing the tutor page for "RemoveChar"
    Then I should see /59:5[789]/

  Examples:
      | button   |
      | "Submit" |
      | "Quit"   |

	@javascript
	Scenario: The user is redirected to the incomplete page when the timer is up
		Given I am logged in as the user "frank"
		And there exists an exercise set "String Manipulation" with "RemoveChar" and "Ex2"
		And the exercise "RemoveChar" has the solution template "remove-letter.c" and the unit test "remove-letter-unit-test.rb"
		And the exercise "RemoveChar" takes "0" minutes to complete
		And I am viewing the tutor page for "RemoveChar"
		Then I should see "Time Is Up For That Exercise!"

	@javascript
  @with-bg-job
	Scenario Outline: The user performs a syntax check
		Given there exists an exercise set "Linked List Basics" with "PointerIntro" and "Ex2"
		And I am logged in as the user "frank"
		And I am viewing the tutor page for "PointerIntro"
		When I fill in the text editor with <code>
		And I press "Check Syntax"
		Then I should see "checking..."
		And I should see <message> within "#message"
		
	Examples:
		| code                           | message                     |
		| "int main(){int i; return 0;}" | "No syntax errors detected" |
		| "int main(){int i return 0;}"  | "syntax error"              | 
		
	@javascript
  @with-bg-job
	Scenario: The user submits a solution to an exercise and it gets graded
    Given I am doing the exercise RemoveChar
		And I press "Submit"
		Then I should see "grading..."
		And I should see "Remove all letters:" within ".gradesheet"
		And I should see "Final Grade: 100" within ".gradesheet"

	@javascript
  @with-bg-job
	Scenario: The user submits a solution to an exercise, but the solution template crashes
		Given I am logged in as the user "frank"
		And there exists an exercise set "String Manipulation" with "RemoveChar" and "Ex2"
		And the exercise "RemoveChar" has the solution template "crap.c" and the unit test "remove-letter-unit-test.rb"
		And I am viewing the tutor page for "RemoveChar"
		When I fill in the text editor with the solution "remove-letter-solution.c"
		And I press "Submit"
		Then I should see "grading..."
		And I should see "Error"
			
  @javascript
	Scenario: The user is redirected to the incomplete page when the timer is up
		Given I am logged in as the user "frank"
		And there exists an exercise set "String Manipulation" with "RemoveChar" and "Ex2"
		And the exercise "RemoveChar" has the solution template "remove-letter.c" and the unit test "remove-letter-unit-test.rb"
		And the exercise "RemoveChar" takes "30" minutes to complete
		And I am viewing the tutor page for "RemoveChar"
    When the exercise "RemoveChar" takes "0" minutes to complete
    And I press "Submit"
    Then I should see "Time Is Up For That Exercise!"
