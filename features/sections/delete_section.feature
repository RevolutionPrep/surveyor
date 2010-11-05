@sections @delete_section
Feature: Delete Section
In order to remove sections that are no longer relevant or wanted
As a survey developer
I want to be able to delete sections from my survey'

Background:
  Given there is a user named "Ryan" with password "password"
  And I log in as "Ryan" with password "password"
  And I create a survey with title "Survey Title" and description "Survey Description"
  Then I should have 1 survey
  When I create a section with title "Section Title" and description "Section Description"
  Then I should have 1 section

  Scenario: Delete Section from Survey with Multiple Sections
    When I create a section with title "Other Section Title" and description "Other Section Description"
    Then I should have 2 sections
    When I go to the sections index page
    And I follow "Delete"
    Then I should be on the section confirm delete page
    And I should see "Are you sure you want to delete this section?"
    When I press "Delete"
    Then I should be on the survey show page
    And I should see "Section deleted."
    And I should have 1 sections


  Scenario: Delete Section from Survey with 1 Section
    When I go to the sections index page
    And I follow "Delete"
    Then I should be on the section confirm delete page
    And I should see "Are you sure you want to delete this section?"
    When I press "Delete"
    Then I should be on the survey show page
    And I should see "Section deleted."
    And I should have 0 sections
  
  Scenario: Cancel delete section
    When I go to the sections index page
    And I follow "Delete"
    Then I should be on the section confirm delete page
    When I follow "Cancel"
    Then I should be on the sections index page

  Scenario: Delete section from the section show page
    When I go to the section show page
    And I follow "Delete"
    Then I should be on the section confirm delete page