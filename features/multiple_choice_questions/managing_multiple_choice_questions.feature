@multiple_choice_questions @managing_multiple_choice_questions
Feature: Require Multiple Choice Questions
In order to provide ensure that outside users answer specific questions
As a survey developer
I want to be able to require specific questions that should be answered by the survey taker

Background:
  Given there is a user named "Ryan" with password "password"
  And I log in as "Ryan" with password "password"
  And I create a survey with title "Survey Title" and description "Survey Description"
  And I create a section with title "Section Title" and description "Section Description"
  And I create a question with statement "What is 1+1?" and type "Multiple Choice" in section with title "Section Title"
  And I create a component with value "2" for question with statement "What is 1+1?"
  Then I should have 1 survey
  And I should have 1 section
  And I should have 1 "Multiple Choice" question
  And I should have 1 component
  When I go to the question edit page

  Scenario: Mark Multiple Choice Question as Required if Required
    When I check "question_required"
    And I press "Update"
    Then I should be on the question show page
    And I should see "(This question is required)"

  Scenario: Do Not Mark Multiple Choice Question as Required if not Required
    When I uncheck "question_required"
    And I press "Update"
    Then I should be on the question show page
    And I should not see "(This question is required)"