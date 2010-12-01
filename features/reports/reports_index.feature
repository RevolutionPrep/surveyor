@reports @reports_index
Feature: Reports index
  In order to see an overview of reports provided by the app,
  as a user,
  I want to be able to view a reports index

Scenario: Create a Valid Survey
  Given there is a user named "Ryan" with password "password"
  And I log in as "Ryan" with password "password"
  And I create a survey with title "Survey Title" and description "Survey Description"
  Then I should have 1 survey
  When I go to the homepage
  And I follow "Reports"
  Then I should be on the reports index page
  