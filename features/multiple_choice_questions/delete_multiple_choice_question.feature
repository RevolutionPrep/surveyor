@multiple_choice_questions @delete_multiple_choice_question
Feature: Delete Multiple Choice Question
In order to remove questions that are no longer relevant or wanted
As a survey developer
I want to be able to delete multiple choice questions

Scenario: Delete a Multiple Choice Question
  Given there is a user named "Ryan" with password "password"
  And I log in as "Ryan" with password "password"
  And I create a survey with title "Survey Title" and description "Survey Description"
  And I create a section with title "Section Title" and description "Section Description"
  And I create a question with statement "What is 1+1?" and type "Multiple Choice" in section with title "Section Title"
  Then I should have 1 survey
  And I should have 1 section
  And I should have 1 "Multiple Choice" question
  When I go to the questions index page
  And I follow "Delete"
  Then I should be on the question confirm delete page
  When I press "Delete"
  Then I should be on the section show page
  And I should have 0 "MultipleChoice" questions