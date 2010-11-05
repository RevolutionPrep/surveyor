Then /^I should have ([0-9]+) "([^\"]*)" questions?$/ do |count,type|
  case type
  when "Multiple Choice"
    MultipleChoiceQuestion.count.should == count.to_i
  end
end

Given /^I create a question with statement "([^\"]*)" and type "([^\"]*)" in section with title "([^\"]*)"$/ do |statement,type,section_name|
  @section = Section.find_by_title(section_name)
  @question = @section.questions.build(:statement => statement)
  @question.user = current_user
  case type
  when "Multiple Choice"
    @question.type = "MultipleChoiceQuestion"
  when "Rating"
    @question.type = "RatingQuestion"
  when "Short Answer"
    @question.type = "ShortAnswerQuestion"
  end
  @section.save!
end