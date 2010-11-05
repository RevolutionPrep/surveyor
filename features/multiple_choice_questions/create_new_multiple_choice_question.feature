@multiple_choice_questions @create_new_multiple_choice_question
Feature: Create New Multiple Choice Question
In order to allow users to answer multiple choice questions in a survey
As a survey developer
I want to be able to add multiple choice questions to a section of my survey

Background:
  Given there is a user named "Ryan" with password "password"
  And I log in as "Ryan" with password "password"
  And I create a survey with title "Survey Title" and description "Survey Description"
  And I create a section with title "Section Title" and description "Section Description"
  Then I should have 1 survey
  And I should have 1 section
  When I go to the questions index page
  And I follow "Create a question"

  Scenario: Create a Multiple Choice Question
    And I fill in "question_statement" with "What is 1+1?"
    And I select "Multiple Choice" from "question_type"
    And I press "Create"
    Then I should be on the question show page
    And I should have 1 "Multiple Choice" question

  Scenario: Create a Multiple Choice Question with no Statement
    And I fill in "question_statement" with ""
    And I select "Multiple Choice" from "question_type"
    And I press "Create"
    Then I should see "Statement cannot be blank"
    And I should see the new question page template
    And I should have 0 "Multiple Choice" questions