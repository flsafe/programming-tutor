Feature: All Exercises
	So that I can increase my interview skills
	As a user
	I want to do the exercises on BlueberryTree

  @javascript
  @with-bg-job
  @exercise
	Scenario: The user submits a solution to an exercise and it gets graded
    Given I have filled in the exercise "Remove Characters From A String" with "solution.c"
		And I press "Submit"
		Then I should see "grading..."
		And I should see "Final Grade: 100" within ".gradesheet"
