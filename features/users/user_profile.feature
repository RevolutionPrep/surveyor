@users @user_profile
Feature: User Profile
In order to maintain my user account information, including my login and password
As a survey creator
I want to be able to edit my user profile information

  Background:
    Given there is a user named "Ryan" with password "password"
    And I log in as "Ryan" with password "password"
    And I am on the homepage
    When I follow "Edit Profile"
    Then I should be on the user edit page

  Scenario: Edit User Profile Username
    When I fill in "Username" with "Dave"
    And I press "Update"
    Then I should be on the surveys index page
    And I should see "Dave"

  Scenario: Edit User Profile Password
    When I fill in "Password" with "newpassword"
    And I fill in "Confirm Password" with "newpassword"
    And I press "Update"
    Then I should be on the surveys index page
    When I follow "Logout"
    Then I should be on the login page
    When I fill in "Username" with "Ryan"
    And I fill in "Password" with "newpassword"
    And I press "Login"
    Then I should be on the homepage
    And I should see "Welcome, Ryan!"

  Scenario: Edit User Profile with Non-Matching Password Confirmation
    When I fill in "Password" with "newpassword"
    And I fill in "Confirm Password" with "drowssapwen"
    And I press "Update"
    Then I should see "Password doesn't match confirmation"
    And I should see the edit user profile page template