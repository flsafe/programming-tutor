
Feature: Blueberry recomends exercises
  So that I can have fun practicing
  As a user
  I want the exercises to fairly challenge  me

  Scenario: Two users have similar ratings, user1 get recomendend an exercise
    Given there exists an exercise set "String Manipulation" with "Ex1" and "Ex2"
    And  there exists an exercise set "Prime Numbers" with "Ex3" and "Ex4" 
    And there exists a user with the username "user1"
    And there exists a user with the username "user2"

    When the user "user1" rates "Ex1" as "too-hard"
    And the user "user1" rates "Ex2" as "too-easy"
    And the user "user1" rates "Ex3" as "good-challenge"

    And the user "user2" rates "Ex1" as "too-hard"
    And the user "user2" rates "Ex2" as "too-easy"
    And the user "user2" rates "Ex3" as "good-challenge"
    And the user "user2" rates "Ex4" as "good-challenge"
    
    Then the recomendation for "user1" should be "Ex4"
