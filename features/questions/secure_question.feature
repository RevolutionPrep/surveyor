@questions @secure_question
Feature: Secure Question
In order to keep users from accessing questions that do not belong to them
As a developer
I want to secure questions

  @allow-rescue
  Scenario: Attempt to View a Survey Iteration Section that does not Belong to You
    Given there is a user named "Ryan" with password "password"
    And there is a user named "Dave" with password "password"
    And I log in as "Ryan" with password "password"
    And I create a survey with title "Survey Title" and description "Survey Description"
    And I create a section with title "Section Title" and description "Section Description"
    And I create a question with statement "What is 1+1?" and type "Multiple Choice" in section with title "Section Title"
    And I logout
    And I log in as "Dave" with password "password"
    When I go to a question edit page belonging to "Ryan"
    Then I should be on the homepage
    And I should see "You do not have access to this asset."