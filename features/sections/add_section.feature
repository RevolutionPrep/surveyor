@sections @add_section
Feature: Add Section
In order to allow surveys to be organized by sections
As a survey developer
I want to be able to add sections to my survey

Background:
  Given there is a user named "Ryan" with password "password"
  And I log in as "Ryan" with password "password"
  And I create a survey with title "Survey Title" and description "Survey Description"
  Then I should have 1 survey
  When I go to the sections index page
  And I follow "Create a section"
  Then I should be on the section new page

  Scenario: Add Valid Section to Survey
    When I fill in "Title" with "Section Title"
    And I fill in "Description" with "Section Description"
    And I press "Create"
    Then I should be on the section show page
    And I should see "Section created."
    And I should see "Section Title"
    And I should see "Section Description"
    And I should have 1 section

  Scenario: Add Invalid Section to Survey (No Title)
    When I fill in "Title" with ""
    And I fill in "Description" with "Section Description"
    And I press "Create"
    Then I should see "Title cannot be blank"
    And I should see the new section page template
    And I should have 0 sections
  
  Scenario: Cancel creation of a survey section
    When I follow "Cancel"
    Then I should be on the sections index page
    And I should have 0 sections