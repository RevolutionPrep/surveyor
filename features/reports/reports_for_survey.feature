@reports @reports_for_survey
Feature: Reports for survey
  In order to see an overview of reports provided for a specific survey,
  as a user,
  I want to be able to view a list of the types of reports available for this survey
@focus
Scenario: Create a Valid Survey
  Given there is a user named "Ryan" with password "password"
  And I log in as "Ryan" with password "password"
  And I create a survey with title "Survey Title" and description "Survey Description"
  Then I should have 1 survey
  When I go to the reports index page
  And I follow "View reports"
  Then I should be on the reports show page
  And I should see "Individual Results"
  And I should see "Sets"
