@api @retrieve_survey
Feature: Retrieve Survey
In order to be able to access my surveys within another client application
As an API user
I want to be able to access the API in XML format

Background:
  Given there is a user named "Ryan" with password "password"
  And I log in as "Ryan" with password "password"
  And I create a survey with title "Survey Title" and description "Survey Description"
  And I create a section with title "Section Title" and description "Section Description"
  And I create a question with statement "What is 1+1?" and type "Multiple Choice" in section with title "Section Title"
  And I create a component with value "1" for question with statement "What is 1+1?"
  And I create a component with value "2" for question with statement "What is 1+1?"
  And I create a component with value "3" for question with statement "What is 1+1?"
  And I create a component with value "4" for question with statement "What is 1+1?"
  And I create a question with statement "What is 2+3?" and type "Multiple Choice" in section with title "Section Title"
  And I create a component with value "4" for question with statement "What is 2+3?"
  And I create a component with value "5" for question with statement "What is 2+3?"
  And I create a component with value "6" for question with statement "What is 2+3?"
  Then I should have 1 survey
  And I should have 1 section
  And I should have 2 "Multiple Choice" questions
  And I should have 7 components

  Scenario: Retrieve a Survey with API Version 1.1
    When I request the API survey page with API version 1.1
    Then the XML response should contain 2 xpath nodes matching "/survey/questions/question"
    And the XML response should contain 2 xpath nodes matching "/survey/questions/question/choices"
    And the XML response should contain 7 xpath nodes matching "/survey/questions/question/choices/choice"
    And the XML response should contain 4 xpath nodes matching "/survey/questions/question[1]/choices/choice"
    And the XML response should contain 3 xpath nodes matching "/survey/questions/question[2]/choices/choice"
    And the XML response xpath node matching "/survey/questions/question[1]/statement" should have content "What is 1+1?"
    And the XML response xpath node matching "/survey/questions/question[1]/sub_type" should have content "MultipleChoiceQuestion"
    And the XML response xpath node matching "/survey/questions/question[1]/multiple_answers" should have content "false"
    And the XML response xpath node matching "/survey/questions/question[1]/user_entered_answer" should have content "false"
    And the XML response xpath node matching "/survey/questions/question[1]/required" should have content "false"
    And the XML response xpath node matching "/survey/questions/question[1]/choices/choice[1]/value" should have content "1"
    And the XML response xpath node matching "/survey/questions/question[1]/choices/choice[2]/value" should have content "2"
    And the XML response xpath node matching "/survey/questions/question[1]/choices/choice[3]/value" should have content "3"
    And the XML response xpath node matching "/survey/questions/question[1]/choices/choice[4]/value" should have content "4"
    And the XML response xpath node matching "/survey/questions/question[2]/statement" should have content "What is 2+3?"
    And the XML response xpath node matching "/survey/questions/question[2]/sub_type" should have content "MultipleChoiceQuestion"
    And the XML response xpath node matching "/survey/questions/question[2]/multiple_answers" should have content "false"
    And the XML response xpath node matching "/survey/questions/question[2]/user_entered_answer" should have content "false"
    And the XML response xpath node matching "/survey/questions/question[2]/required" should have content "false"
    And the XML response xpath node matching "/survey/questions/question[2]/choices/choice[1]/value" should have content "4"
    And the XML response xpath node matching "/survey/questions/question[2]/choices/choice[2]/value" should have content "5"
    And the XML response xpath node matching "/survey/questions/question[2]/choices/choice[3]/value" should have content "6"

  Scenario: Retrieve a Survey with Bad API Key
    When I request the bad API survey page with API version 1.1
    Then I should get a response with status 404

  Scenario: Retrieve a Survey with Non-Existant API Version
    When I request the API survey page with API version 0.0
    Then I should get a response with status 405