
Feature: Blueberry recomends exercises
  So that I can have fun practicing
  As a user
  I want the exercises to fairly challenge  me

  @no-txn
  @with-rec-engine
  Scenario: Two users have similar ratings, user1 get recomendend an exercise
    Given there exists an exercise set "String Manipulation" with "Ex1" and "Ex2"
    And  there exists an exercise set "Prime Numbers" with "Ex3" and "Ex4" 
    And there exists a user with the username "user1"
    And there exists a user with the username "user2"

    When the user "user1" rates "Ex1" as "too-hard"
    And the user "user2" rates "Ex1" as "too-hard"

    And the user "user1" rates "Ex2" as "too-easy"
    And the user "user2" rates "Ex2" as "too-easy"

    And the user "user2" rates "Ex3" as "good-challenge"
    And the user "user2" rates "Ex4" as "good-challenge"

    And the user "user1" rates "Ex3" as "good-challenge"

    And I wait for "4" seconds

    Then the recomendation for "user1" should be "Ex4"

  Scenario: Recomendations are dispalyed to the user
    Given there exists a user with the username "Frank"
    And there exists an exercise set "String Manipulation" with "Ex1" and "Ex2"
    And  there exists an exercise set "Prime Numbers" with "Ex3" and "Ex4" 
    And there exists a recomendation for "Ex4" for "Frank"
    And I log in as "Frank"
    When I am on my home page
    Then I should see /Ex4/
  
  Scenario: A random exercise is displayed to the user if there are no recomendations
    Given there exists an exercise set "String Manipulation" with "Ex1" and "Ex2"
    And  there exists an exercise set "Prime Numbers" with "Ex3" and "Ex4" 
    And I am logged in as the user "Frank"
    When I am on my home page
    Then I should see /(Ex1|Ex2|Ex3|Ex4)/

  Scenario: A random exercise doesn't change if the page is reloaded
    Given there exists an exercise set "String Manipulation" with "Ex1" and "Ex2"
    And  there exists an exercise set "Prime Numbers" with "Ex3" and "Ex4" 
    And I am logged in as the user "Frank"
    And I am on my home page
    And I note /(Ex1|Ex2|Ex3|Ex4)/
    When I am on my home page
    Then I should always see what I noted on "my home page"
