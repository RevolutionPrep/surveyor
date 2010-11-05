Then /^I should have ([0-9]+) components?$/ do |count|
  Component.count.should == count.to_i
end

Given /^I create a component with value "([^\"]*)" for question with statement "([^\"]*)"$/ do |value,question_statement|
  @question = Question.find_by_statement(question_statement)
  @component = @question.components.build(:value => value, :user_id => User.first.id)
  @question.save!
end