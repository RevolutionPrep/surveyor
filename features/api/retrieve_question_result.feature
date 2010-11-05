@api @retrieve_question_result
Feature: Retrieve Question Result
In order provide the results to individual questions on another client application
As an API user
I want to able to retrieve question results through the API

Background:
  Given there is a user named "Ryan" with password "password"
  And I log in as "Ryan" with password "password"
  And I create a survey with title "Survey Title" and description "Survey Description"
  And I create a section with title "Section Title" and description "Section Description"
  And I create a question with statement "What is 1+1?" and type "Multiple Choice" in section with title "Section Title"
  And I create a component with value "2" for question with statement "What is 1+1?"
  And I create a component with value "3" for question with statement "What is 1+1?"
  And I create a rating scale called "Ease" with values "Not At All,Somewhat,Very"
  And I create a question with statement "How easy is this?" and type "Rating" in section with title "Section Title"
  And I assign the "Ease" rating scale to the question "How easy is this?"
  And I create a question with statement "What is my name?" and type "Short Answer" in section with title "Section Title"
  And I create a survey result
  And I create a question result of "2" for question with statement "What is 1+1?"
  And I create a question result of "Very" for question with statement "How easy is this?"
  And I create a question result of "Ryan" for question with statement "What is my name?"
  Then I should have 1 survey result
  And I should have 3 question results

  Scenario: Retrieve a Question Result using API Version 1.1
    When I request the API question result page for "What is 1+1?,How easy is this?,What is my name?" with API version 1.1
    Then the XML response should contain 3 xpath nodes matching "/question_result/questions/question"
    Then the XML response should contain 7 xpath nodes matching "/question_result/questions/question/choices/choice"

  Scenario: Retrieve an invalid Question Result using the API version 1.1
    When I request the bad API question result page with API version 1.1
    Then I should get a response with status 404

  Scenario: Retrieve a survey result using a Non-Existant API version
    When I request the API question result page for "What is 1+1?,How easy is this?,What is my name?" with API version 0.0
    Then I should get a response with status 405