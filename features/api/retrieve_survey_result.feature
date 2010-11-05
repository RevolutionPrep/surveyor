@api @retrieve_survey_result
Feature: Retrieve Survey Result
In order display survey results on a client application
As an API user
I want to be able to retrieve a survey result using the API

Background:
  Given there is a user named "Ryan" with password "password"
  And I log in as "Ryan" with password "password"
  And I create a survey with title "Survey Title" and description "Survey Description"
  And I create a section with title "Section Title" and description "Section Description"
  And I create a question with statement "What is 1+1?" and type "Multiple Choice" in section with title "Section Title"
  And I create a component with value "2" for question with statement "What is 1+1?"
  And I create a component with value "3" for question with statement "What is 1+1?"
  And I create a rating scale called "Ease" with values "Not At All,Somewhat,Very"
  And I create a question with statement "How easy is this?" and type "Rating" in section with title "Section Title"
  And I assign the "Ease" rating scale to the question "How easy is this?"
  And I create a question with statement "What is my name?" and type "Short Answer" in section with title "Section Title"
  And I create a survey result
  And I create a question result of "2" for question with statement "What is 1+1?"
  And I create a question result of "Very" for question with statement "How easy is this?"
  And I create a question result of "Ryan" for question with statement "What is my name?"
  And I create a survey result
  And I create a question result of "3" for question with statement "What is 1+1?"
  And I create a question result of "Somewhat" for question with statement "How easy is this?"
  And I create a question result of "Dave" for question with statement "What is my name?"
  Then I should have 2 survey result
  And I should have 6 question results

  Scenario: Retrieve a survey result using API version 1.0
    When I request the API survey results page with API version 1.0
    Then the XML response should contain 3 xpath nodes matching "/survey_result/question_results/question_result"
    And the XML response xpath node matching "/survey_result/question_results/question_result[1]/question/statement" should have content "What is 1+1?"
    And the XML response xpath node matching "/survey_result/question_results/question_result[1]/question/sub_type" should have content "MultipleChoiceQuestion"
    And the XML response xpath node matching "/survey_result/question_results/question_result[1]/question/multiple_answers" should have content "false"
    And the XML response xpath node matching "/survey_result/question_results/question_result[1]/question/user_entered_answer" should have content "false"
    And the XML response xpath node matching "/survey_result/question_results/question_result[1]/question/required" should have content "false"
    And the XML response should contain 2 xpath node matching "/survey_result/question_results/question_result[1]/question/choices/choice"
    And the XML response xpath node matching "/survey_result/question_results/question_result[1]/question/choices/choice[1]/value" should have content "2"
    And the XML response xpath node matching "/survey_result/question_results/question_result[2]/question/statement" should have content "How easy is this?"
    And the XML response xpath node matching "/survey_result/question_results/question_result[2]/question/sub_type" should have content "RatingQuestion"
    And the XML response xpath node matching "/survey_result/question_results/question_result[2]/question/multiple_answers" should have content "false"
    And the XML response xpath node matching "/survey_result/question_results/question_result[2]/question/user_entered_answer" should have content "false"
    And the XML response xpath node matching "/survey_result/question_results/question_result[2]/question/required" should have content "false"
    And the XML response should contain 3 xpath node matching "/survey_result/question_results/question_result[2]/question/choices/choice"
    And the XML response xpath node matching "/survey_result/question_results/question_result[2]/question/choices/choice[1]/value" should have content "Not At All"
    And the XML response xpath node matching "/survey_result/question_results/question_result[2]/question/choices/choice[2]/value" should have content "Somewhat"
    And the XML response xpath node matching "/survey_result/question_results/question_result[2]/question/choices/choice[3]/value" should have content "Very"
    And the XML response xpath node matching "/survey_result/question_results/question_result[3]/question/statement" should have content "What is my name?"
    And the XML response xpath node matching "/survey_result/question_results/question_result[3]/question/sub_type" should have content "ShortAnswerQuestion"
    And the XML response xpath node matching "/survey_result/question_results/question_result[3]/question/multiple_answers" should have content "false"
    And the XML response xpath node matching "/survey_result/question_results/question_result[3]/question/user_entered_answer" should have content "false"
    And the XML response xpath node matching "/survey_result/question_results/question_result[3]/question/required" should have content "false"
    And the XML response should contain 0 xpath nodes matching "/survey_result/question_results/question_result[3]/question/choices/choice"
    And the XML response xpath node matching "/survey_result/question_results/question_result[3]/response" should have content "Ryan"

  Scenario: Retrieve an invalid survey result using API version 1.0
    When I request the bad API survey results page with API version 1.0
    Then I should get a response with status 404

  Scenario: Retrieve a survey result using API version 1.1
    When I request the API survey results page with API version 1.1
    Then the XML response should contain 1 xpath node matching "/survey_result"
    Then the XML response should contain 3 xpath nodes matching "/survey_result/question_results/question_result"
    And the XML response xpath node matching "/survey_result/question_results/question_result[1]/question/statement" should have content "What is 1+1?"
    And the XML response xpath node matching "/survey_result/question_results/question_result[1]/question/sub_type" should have content "MultipleChoiceQuestion"
    And the XML response xpath node matching "/survey_result/question_results/question_result[1]/question/multiple_answers" should have content "false"
    And the XML response xpath node matching "/survey_result/question_results/question_result[1]/question/user_entered_answer" should have content "false"
    And the XML response xpath node matching "/survey_result/question_results/question_result[1]/question/required" should have content "false"
    And the XML response should contain 2 xpath node matching "/survey_result/question_results/question_result[1]/question/choices/choice"
    And the XML response xpath node matching "/survey_result/question_results/question_result[1]/question/choices/choice[1]/value" should have content "2"
    And the XML response xpath node matching "/survey_result/question_results/question_result[2]/question/statement" should have content "How easy is this?"
    And the XML response xpath node matching "/survey_result/question_results/question_result[2]/question/sub_type" should have content "RatingQuestion"
    And the XML response xpath node matching "/survey_result/question_results/question_result[2]/question/multiple_answers" should have content "false"
    And the XML response xpath node matching "/survey_result/question_results/question_result[2]/question/user_entered_answer" should have content "false"
    And the XML response xpath node matching "/survey_result/question_results/question_result[2]/question/required" should have content "false"
    And the XML response should contain 3 xpath node matching "/survey_result/question_results/question_result[2]/question/choices/choice"
    And the XML response xpath node matching "/survey_result/question_results/question_result[2]/question/choices/choice[1]/value" should have content "Not At All"
    And the XML response xpath node matching "/survey_result/question_results/question_result[2]/question/choices/choice[2]/value" should have content "Somewhat"
    And the XML response xpath node matching "/survey_result/question_results/question_result[2]/question/choices/choice[3]/value" should have content "Very"
    And the XML response xpath node matching "/survey_result/question_results/question_result[3]/question/statement" should have content "What is my name?"
    And the XML response xpath node matching "/survey_result/question_results/question_result[3]/question/sub_type" should have content "ShortAnswerQuestion"
    And the XML response xpath node matching "/survey_result/question_results/question_result[3]/question/multiple_answers" should have content "false"
    And the XML response xpath node matching "/survey_result/question_results/question_result[3]/question/user_entered_answer" should have content "false"
    And the XML response xpath node matching "/survey_result/question_results/question_result[3]/question/required" should have content "false"
    And the XML response should contain 0 xpath nodes matching "/survey_result/question_results/question_result[3]/question/choices/choice"
    And the XML response xpath node matching "/survey_result/question_results/question_result[3]/response" should have content "Ryan"

  Scenario: Retrieve an invalid survey result using API version 1.1
    When I request the bad API survey results page with API version 1.1
    Then I should get a response with status 404

  Scenario: Retrieve a survey result using a Non-Existant API version
    When I request the API survey results page with API version 0.0
    Then I should get a response with status 405