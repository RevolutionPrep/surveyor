require 'webrat'

Then /^I should have ([0-9]+) users?$/ do |count|
  User.count.should == count.to_i
end

Given /^there is a user named "([^\"]*)" with password "([^\"]*)"$/ do |username, password|
  User.create!(:username => username, :password => password, :password_confirmation => password)
end

Given /^I log in as "([^\"]*)" with password "([^\"]*)"$/ do |username, password|
  visit path_to("the login page")
  fill_in("Username", :with => "#{username}")
  fill_in("Password", :with => "#{password}")
  click_button("Login")
end

Given /^I logout$/ do
  click_link('Logout')
end

module UserHelpers

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

end

World(UserHelpers)