@users @user_registration
Feature: User Registration
In order to gain access to the application
As a survey creator
I want to be able to register myself with a login and password

Background:
  Given there is a user named "Admin" with password "password"
  And I log in as "Admin" with password "password"
  And I am on the user new page

  Scenario: Register New User
    When I fill in "Username" with "Ryan"
    And I fill in "Password" with "password"
    And I fill in "Confirm Password" with "password"
    When I press "Register"
    Then I should be on the surveys index page
    And I should see "Registration successful! Welcome, Ryan."
    And I should have 2 users

  Scenario: Register with Non-Matching Password Confirmation
    When I fill in "Username" with "Ryan"
    And I fill in "Password" with "password"
    And I fill in "Confirm Password" with "badpassword"
    And I press "Register"
    Then I should see "Password doesn't match confirmation"
    And I should see the user signup page template

  Scenario: Register with Existing Username
    Given there is a user named "Ryan" with password "password"
    When I fill in "Username" with "Ryan"
    And I fill in "Password" with "password"
    And I fill in "Confirm Password" with "password"
    When I press "Register"
    Then I should see "Username has already been taken"
    And I should see the user signup page template