@multiple_choice_questions @edit_multiple_choice_question_components
Feature: Edit Multiple Choice Question Components
In order to offer different solutions to existing questions
As a survey developer
I want to be able to add/update/remove components from a multiple choice question

Background:
  Given there is a user named "Ryan" with password "password"
  And I log in as "Ryan" with password "password"
  And I create a survey with title "Survey Title" and description "Survey Description"
  And I create a section with title "Section Title" and description "Section Description"
  And I create a question with statement "What is 1+1?" and type "Multiple Choice" in section with title "Section Title"
  Then I should have 1 survey
  And I should have 1 section
  And I should have 1 "Multiple Choice" question

  Scenario: Update a Multiple Choice Question with no Components
    When I go to the question edit page
    And I press "Update"
    Then I should be on the question show page
    And I should have 1 "Multiple Choice" question
    And I should have 0 components