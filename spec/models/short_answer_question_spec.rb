require 'spec_helper'

module ShortAnswerQuestionSpecHelpers

  def valid_short_answer_question_attributes
    {
      :statement  => "statement",
      :section_id => 1
    }
  end

end

describe ShortAnswerQuestion do

  include ShortAnswerQuestionSpecHelpers

  before(:each) do
    @short_answer_question = ShortAnswerQuestion.new
  end

  it "is valid given valid attributes" do
    @short_answer_question.attributes = valid_short_answer_question_attributes
    @short_answer_question.should be_valid
  end

  it "has 1 error on statement when statement is blank" do
    @short_answer_question.attributes = valid_short_answer_question_attributes.except(:statement)
    @short_answer_question.should have(1).error_on(:statement)
  end

end

describe ShortAnswerQuestion, ".type_as_string" do
  include ShortAnswerQuestionSpecHelpers
  
  before(:each) do
    @short_answer_question = ShortAnswerQuestion.new
  end
  
  it "returns the type formatted as a descriptive string" do
    @short_answer_question.attributes = valid_short_answer_question_attributes
    @short_answer_question.type_as_string.should eql("Short Answer")
  end
  
end

describe ShortAnswerQuestion, ".count" do
  
  it "returns a number indicating the count of question results with specified question id given a set of survey result ids"
  
end