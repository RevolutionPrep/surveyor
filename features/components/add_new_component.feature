@components @add_new_component
Feature: Add New Component
In order to allow questions to have extra information associated to them, for question choices, comments, etc.
As a survey developer
I want to be able to add components to questions

Background:
  Given there is a user named "Ryan" with password "password"
  And I log in as "Ryan" with password "password"
  And I create a survey with title "Survey Title" and description "Survey Description"
  And I create a section with title "Section Title" and description "Section Description"
  And I create a question with statement "What is 1+1?" and type "Multiple Choice" in section with title "Section Title"
  Then I should have 1 survey
  And I should have 1 section
  And I should have 1 "Multiple Choice" question
  When I go to the question edit page
  And I press "Add"
  When I fill in "option_" with "value = 1"

  Scenario: Add a Component to a Multiple Choice Question and Update
    When I press "Update"
    Then I should be on the question show page
    And I should have 1 component
    And I should see "1"

  Scenario: Add a Component to a Multiple Choice Question and Save
    When I press "Update"
    Then I should be on the question show page
    And I should have 1 component