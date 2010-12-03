@results @results_index
Feature: Results index
  In order to see an index of results for a given survey,
  as a user,
  I want to be able to view a results index

Scenario: View results index
  Given there is a user named "Ryan" with password "password"
  And I log in as "Ryan" with password "password"
  And I create a survey with title "Survey Title" and description "Survey Description"
  Then I should have 1 survey
  When I go to the reports show page
  And I follow "View" within "table.default tr:nth-child(2) td:last"
  Then I should be on the results index page
