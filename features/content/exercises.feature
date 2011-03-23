Feature: All Exercises
	So that I can increase my interview skills
	As a user
	I want to do the exercises on BlueberryTree

  @javascript
  @with-bg-job
  @exercise
	Scenario Outline: The user submits a solution to an exercise and it gets graded
    Given I have filled in the exercise <exercise> with <file> 
		And I press "Submit"
		Then I should see "grading..."
		And I should see "100" within ".gradesheet"

  Examples:
      | exercise                                   | file          |
      | "Remove Characters From A String"          | "solution.c"  |
      | "Remove Characters From A String"          | "solution2.c" |
      | "Remove Characters From A String"          | "solution3.c" |
      | "Reverse Characters In A Character String" | "solution.c"  |
      | "Implement A Stack Using A Linked List"    | "solution.c"  |
      | "Fizz Buzz Strikes Again"                  | "solution.c"  |
      | "A Grand Common Divide"                    | "solution.c"  |
      | "A Grand Common Divide"                    | "solution1.c" |

      | "Show Off Your Reverse Linked List Printing Skills" | "solution.c"  |
      | "Show Off Your Reverse Linked List Printing Skills" | "solution2.c" |
      | "Show Off Your Reverse Linked List Printing Skills" | "solution3.c" |
