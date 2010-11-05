Then /^I should have ([0-9]+) sections?$/ do |count|
  Section.count.should == count.to_i
end

Given /^I create a section with title "([^\"]*)" and description "([^\"]*)"$/ do |title, description|
  visit path_to("the sections index page")
  click_link("Create a section")
  fill_in("Title", :with => title)
  fill_in("Description", :with => description)
  click_button("Create")
end