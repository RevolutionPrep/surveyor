@users @user_login
Feature: User Login
In order to gain access to the application
As a survey creator
I want to be able to login to my account using my login and password

Background:
  Given there is a user named "Ryan" with password "password"
  And I am on the login page

Scenario: Login as Valid User
  When I fill in "Username" with "Ryan"
  And I fill in "Password" with "password"
  And I press "Login"
  Then I should be on the homepage
  And I should see "Welcome, Ryan!"

Scenario: Login with Invalid Password
  When I fill in "Username" with "Ryan"
  And I fill in "Password" with "badpassword"
  And I press "Login"
  Then I should see "Password is not valid"

Scenario: Login When No Valid User Exists
  When I fill in "Username" with "Kris"
  And I fill in "Password" with "password"
  And I press "Login"
  Then I should see the login page template
  And I should see "Username is not valid"