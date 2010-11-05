@users @user_logout
Feature: User Logout
In order to securely end my session with the application
As a survey creator
I want to be able to logout, rendering my session over, and securing the application

Background:
  Given there is a user named "Ryan" with password "password"
  And I log in as "Ryan" with password "password"
  And I am on the homepage

  Scenario: Logout
    When I follow "Logout"
    Then I should be on the login page
    And I should see "Goodbye."