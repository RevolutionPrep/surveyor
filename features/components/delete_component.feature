@components @delete_component
Feature: Delete Component
In order to remove components that are no longer relevant or wanted
As a survey developer
I want to be able to delete components from questions

Scenario: Remove an Existing Component on a Multiple Choice Question
  Given there is a user named "Ryan" with password "password"
  And I log in as "Ryan" with password "password"
  And I create a survey with title "Survey Title" and description "Survey Description"
  And I create a section with title "Section Title" and description "Section Description"
  And I create a question with statement "What is 1+1?" and type "Multiple Choice" in section with title "Section Title"
  And I create a component with value "1" for question with statement "What is 1+1?"
  And I create a component with value "2" for question with statement "What is 1+1?"
  Then I should have 1 survey
  And I should have 1 section
  And I should have 1 "Multiple Choice" question
  And I should have 2 components
  When I go to the question edit page
  When I follow "Delete"
  Then I should be on the component confirm delete page
  When I press "Delete"
  Then I should be on the question edit page
  And I should see "Answer choice successfully deleted."
  And I should have 1 component