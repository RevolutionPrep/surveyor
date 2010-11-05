@users @page_access
Feature: Page Access
In order to ensure that users can only view the internal application pages when logged in
As a developer
I want to secure all pages that should be accessible only by those who are logged in

Background:
  Given there is a user named "Ryan" with password "password"
  And I log in as "Ryan" with password "password"
  And I create a survey with title "Survey Title" and description "Survey Description"
  And I create a section with title "Section Title" and description "Section Description"
  And I create a question with statement "Question Statement" and type "Multiple Choice" in section with title "Section Title"
  And I logout

  Scenario Outline: User should be directed to login if accessing a protected page
    When I go to <page>
    Then I should see "You must be logged in to access this page"

  Scenarios: visiting the homepage
    | page                              |
    | the homepage                      |
    | the user edit page                |
    | the surveys index page            |
    | the survey show page              |
    | the survey edit page              |
    | the survey confirm delete page    |
    | the sections index page           |
    | the section new page              |
    | the section show page             |
    | the section edit page             |
    | the section confirm delete page   |
    | the questions index page          |
    | the question new page             |
    | the question show page            |
    | the question edit page            |
    | the question confirm delete page  |
