@surveys @edit_survey
Feature: Edit Survey
In order to change surveys that already exist
As a survey developer
I want to be able to edit surveys from my surveys index

Background:
  Given there is a user named "Ryan" with password "password"
  And I log in as "Ryan" with password "password"
  And I create a survey with title "Survey Title" and description "Survey Description"
  And I create a section with title "Section Title" and description "Section Description"
  Then I should have 1 survey
  And I should have 1 section

  Scenario: Edit survey
    When I go to the survey edit page
    When I fill in "Title" with "New Title"
    And I fill in "Description" with "New Description"
    And I press "Update"
    Then I should be on the survey show page
    And I should see "New Title"
    And I should see "New Description"

  Scenario: Cancel editing of survey
    When I go to the survey edit page
    When I follow "Cancel"
    Then I should be on the survey show page
    And I should see "Survey Title"
    And I should see "Survey Description"