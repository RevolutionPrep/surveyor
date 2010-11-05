@api @create_survey_result
Feature: Create Survey Result
In order to store the results of survey into the applications database from another client application's front-end
As an API user
I want to be able to post a survey result to the API interface

Background:
  Given there is a user named "Ryan" with password "password"
  And I log in as "Ryan" with password "password"
  And I create a survey with title "Survey Title" and description "Survey Description"
  And I create a section with title "Section Title" and description "Section Description"
  And I create a question with statement "What is 1+1?" and type "Multiple Choice" in section with title "Section Title"
  And I create a component with value "2" for question with statement "What is 1+1?"
  And I create a rating scale called "Ease" with values "Not At All,Somewhat,Very"
  And I create a question with statement "How easy is this?" and type "Rating" in section with title "Section Title"
  And I assign the "Ease" rating scale to the question "How easy is this?"
  And I create a question with statement "What is my name?" and type "Short Answer" in section with title "Section Title"

  Scenario: Post a Valid Survey Result using API version 1.1
    When I post a valid survey result with API version 1.1
    Then I should have 1 survey result
    And I should have 3 question results

  Scenario: Post an Invalid Survey Result using API version 1.1
    When I post an invalid survey result with API version 1.1
    Then I should get a response with status 404

  Scenario: Post a Survey Result using Non-Existant API Version
    When I post a valid survey result with API version 0.0
    Then I should get a response with status 405