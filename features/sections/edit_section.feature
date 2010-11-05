@sections @edit_section
Feature: Edit Section
In order to allow surveys to have flexible titles and descriptions
As a survey developer
I want to be able to edit information related to sections of my survey

Background:
  Given there is a user named "Ryan" with password "password"
  And I log in as "Ryan" with password "password"
  And I create a survey with title "Survey Title" and description "Survey Description"
  Then I should have 1 survey
  When I create a section with title "Section Title" and description "Section Description"
  Then I should have 1 section
  When I go to the section show page

  Scenario: Edit Title and Description
    When I follow "Edit"
    Then I should be on the section edit page
    When I fill in "Title" with "Revised Title"
    And I fill in "Description" with "Revised Description"
    And I press "Update"
    Then I should be on the section show page
    And I should see "Section updated."
    And I should see "Revised Title"
    And I should not see "Section Title"
    And I should not see "Section Description"
    And I should have 1 section