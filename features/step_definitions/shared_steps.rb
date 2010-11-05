Then /^I should see (.+) template$/ do |page|
  case page
  when 'the user signup page'
    response.should contain('Signup')
    response.should contain('Create New User')
    response.should contain('Username')
    response.should contain('Password')
    response.should contain('Confirm Password')
  when 'the edit user profile page'
    response.should contain("Editing Ryan's Profile")
    response.should contain('Username')
    response.should contain('Password')
    response.should contain('Confirm Password')
  when 'the login page'
    response.should contain('Username')
    response.should contain('Password')
  when 'the new iteration page'
    response.should contain('Create a New Survey Iteration')
    response.should contain('Title')
    response.should contain('Description')
  when 'the new section page'
    response.should contain('Create a New Survey Section')
    response.should contain('Title')
    response.should contain('Description')
  when 'the new question page'
    response.should contain('Create a New Survey Question')
    response.should contain('Question:')
    response.should contain('Please choose a type:')
  end
end