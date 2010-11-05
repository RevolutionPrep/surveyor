@sections @secure_section
Feature: Secure Section
In order to keep users from accessing another user's survey iteration section
As a developer
I want to secure survey iteration sections

@allow-rescue
Scenario: Attempt to View a Survey Iteration Section that does not Belong to You
  Given there is a user named "Ryan" with password "password"
  And there is a user named "Dave" with password "password"
  And I log in as "Ryan" with password "password"
  And I create a survey with title "Survey Title" and description "Survey Description"
  And I create a section with title "Section Title" and description "Section Description"
  And I logout
  And I log in as "Dave" with password "password"
  When I go to a section page belonging to "Ryan"
  Then I should be on the homepage
  And I should see "You do not have access to this asset."