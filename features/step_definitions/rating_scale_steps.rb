Given /^I create a rating scale called "([^\"]*)" with values "([^\"]*)"$/ do |name, keys|
  rating_scale = RatingScale.create(:name => name, :user_id => current_user.id)
  keys.split(',').each_with_index do |key,index|
    RatingLabel.create(:rating_scale_id => rating_scale.id, :key => key, :value => index, :user_id => User.first.id)
  end
end

Given /^I assign the "([^\"]*)" rating scale to the question "([^\"]*)"$/ do |rating_scale, question|
  question = Question.find_by_statement(question)
  question.rating_scale_id = current_user.rating_scales.find_by_name(rating_scale).id
  question.save
end