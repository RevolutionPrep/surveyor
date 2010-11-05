@multiple_choice_questions @edit_multiple_choice_question_statement
Feature: Edit Multiple Choice Question Statement
In order to update the emphasis of a multiple choice question
As a survey developer
I want to be able to edit the statement

Background:
  Given there is a user named "Ryan" with password "password"
  And I log in as "Ryan" with password "password"
  And I create a survey with title "Survey Title" and description "Survey Description"
  And I create a section with title "Section Title" and description "Section Description"
  And I create a question with statement "What is 1+1?" and type "Multiple Choice" in section with title "Section Title"
  Then I should have 1 survey
  And I should have 1 section
  And I should have 1 "Multiple Choice" question
  When I go to the questions index page
  And I follow "What is 1+1?"
  Then I should be on the question show page
  When I follow "Edit"
  Then the "Question:" field should contain "What is 1+1?"
  And I fill in "question_statement" with "What is 2+2?"

  Scenario: Edit a Multiple Choice Question Statement and Save
    And I press "Update"
    Then I should be on the question show page
    And I should have 1 "Multiple Choice" question
    And I should see "What is 2+2?"
