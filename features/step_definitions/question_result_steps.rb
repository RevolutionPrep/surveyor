Then /^I should have ([0-9]+) question results?$/ do |count|
  QuestionResult.count.should eql(count.to_i)
end

Given /^I create a question result of "([^\"]*)" for question with statement "([^\"]*)"$/ do |result, statement|
  question = Question.find_by_statement(statement)
  question_result = QuestionResult.new(:survey_result_id => current_user.survey_results.last.id, :question_id => question.id, :user_id => current_user.id)
  case question.type
  when "MultipleChoiceQuestion"
    question_result.component_id = Component.find_by_value(result).id
  when "RatingQuestion"
    question_result.rating_label_id = RatingLabel.find_by_key(result).id
  when "ShortAnswerQuestion"
    question_result.response = result
  end
  question_result.save
end