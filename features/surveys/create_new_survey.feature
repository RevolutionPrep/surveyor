@surveys @create_new_survey
Feature: Create New Survey
In order to have surveys to be taken
As a survey developer
I want to be able to add new surveys to my surveys index

Background:
  Given there is a user named "Ryan" with password "password"
  And I log in as "Ryan" with password "password"
  And I should have 0 surveys
  When I follow "Surveys"
  Then I should be on the surveys index page
  And I follow "Create a survey"
  Then I should be on the survey new page

  Scenario: Create a Valid Survey
    When I fill in "Title" with "Survey Title"
    And I fill in "Description" with "Survey Description"
    And I press "Create"
    Then I should be on the survey show page
    And I should have 1 survey

  Scenario: Create an Invalid Survey (No Title)
    When I fill in "Description" with "Survey Description"
    And I press "Create"
    Then I should see "Title cannot be blank"
    And I should see the survey new page template

  Scenario: Cancel from New Survey Page
    When I go to the surveys index page
    Then I should have 0 surveys