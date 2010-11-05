Then /^I should have ([0-9]+) iterations?$/ do |count|
  Iteration.count.should == count.to_i
end

Then /^I should have ([0-9]+) active iterations?$/ do |count|
  Iteration.count(:conditions => ['active = ?', true]).should == count.to_i
end

Then /^I should have ([0-9]+) inactive iterations?$/ do |count|
  Iteration.count(:conditions => ['active = ?', false]).should == count.to_i
end

Given /^I branch a new iteration with title "([^\"]*)" and description "([^\"]*)"$/ do |title, description|
  visit path_to("the show iteration page")
  click_link("New Iteration")
  fill_in("Title", :with => title)
  fill_in("Description", :with => description)
  click_button("Branch")
end