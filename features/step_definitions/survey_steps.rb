Then /^I should have ([0-9]+) surveys?$/ do |count|
  Survey.count.should == count.to_i
end


Given /^I create a survey with title "([^\"]*)" and description "([^\"]*)"$/ do |title, description|
  visit(path_to('the surveys index page'))
  click_link('Create a survey')
  fill_in('Title', :with => title)
  fill_in('Description', :with => description)
  click_button('Create')
end