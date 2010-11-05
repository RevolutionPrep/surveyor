require 'spec_helper'

module MultipleChoiceQuestionSpecHelpers

  def valid_multiple_choice_question_attributes
    {
      :statement  => "statement",
      :section_id => 1
    }
  end

end

describe MultipleChoiceQuestion do

  include MultipleChoiceQuestionSpecHelpers

  before(:each) do
    @multiple_choice_question = MultipleChoiceQuestion.new
  end

  it "is valid given valid attributes" do
    @multiple_choice_question.attributes = valid_multiple_choice_question_attributes
    @multiple_choice_question.should be_valid
  end

  it "has 1 error on statement when statement is blank" do
    @multiple_choice_question.attributes = valid_multiple_choice_question_attributes.except(:statement)
    @multiple_choice_question.should have(1).error_on(:statement)
  end

end

describe MultipleChoiceQuestion, ".type_as_string" do
  include MultipleChoiceQuestionSpecHelpers
  
  before(:each) do
    @multiple_choice_question = MultipleChoiceQuestion.new
  end
  
  it "returns the type formatted as a descriptive string" do
    @multiple_choice_question.attributes = valid_multiple_choice_question_attributes
    @multiple_choice_question.type_as_string.should eql("Multiple Choice")
  end
  
end

describe ".count" do
  
  it "returns a number indicating the count of question results with specified question id given a set of survey result ids"
  
end