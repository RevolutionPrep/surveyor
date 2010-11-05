@surveys @delete_survey
Feature: Delete Survey
In order to remove surveys that are no longer relevant or wanted
As a survey developer
I want to be able to delete surveys from my surveys index

Background:
  Given there is a user named "Ryan" with password "password"
  And I log in as "Ryan" with password "password"
  And I create a survey with title "Survey Title" and description "Survey Description"
  And I create a section with title "Section Title" and description "Section Description"
  Then I should have 1 survey
  And I should have 1 section
  When I go to the surveys index page
  And I follow "Delete"
  Then I should be on the survey confirm delete page
  And I should see "Are you sure you want to delete this survey?"

  Scenario: Delete and Confirm Deletion of Dependencies
    When I press "Delete"
    Then I should be on the surveys index page
    And I should see "Survey deleted."
    And I should have 0 surveys
    And I should have 0 sections

  Scenario: Cancel from Confirm Delete Page
    When I follow "Cancel"
    Then I should be on the survey show page
    And I should have 1 survey
  
  Scenario: Delete from the survey show page
    When I press "Delete"
    Then I should be on the surveys index page
    And I should have 0 surveys