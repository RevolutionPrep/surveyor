@components @edit_component
Feature: Edit Component
In order to make components belonging to questions flexible
As a survey developer
I want to able to edit the contents of a component

Scenario: Edit an Existing Component on a Multiple Choice Question
  Given there is a user named "Ryan" with password "password"
  And I log in as "Ryan" with password "password"
  And I create a survey with title "Survey Title" and description "Survey Description"
  And I create a section with title "Section Title" and description "Section Description"
  And I create a question with statement "What is 1+1?" and type "Multiple Choice" in section with title "Section Title"
  And I create a component with value "1" for question with statement "What is 1+1?"
  Then I should have 1 survey
  And I should have 1 section
  And I should have 1 "Multiple Choice" question
  And I should have 1 component
  When I go to the question edit page
  When I fill in "option_1" with "2"
  And I press "Update"
  Then I should be on the question show page
  And I should see "2"
  And I should have 1 component