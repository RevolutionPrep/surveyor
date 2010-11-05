Then /^I should have ([0-9]+) survey results?$/ do |count|
  SurveyResult.count.should eql(count.to_i)
end

Given /^I create a survey result$/ do
  SurveyResult.create!(:user_id => current_user.id, :survey_id => current_user.surveys.first.id)
end