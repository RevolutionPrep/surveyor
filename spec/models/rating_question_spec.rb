require 'spec_helper'

module RatingQuestionSpecHelpers

  def valid_rating_question_attributes
    {
      :statement  => "statement",
      :section_id => 1
    }
  end

end

describe RatingQuestion do

  include RatingQuestionSpecHelpers

  before(:each) do
    @rating_question = RatingQuestion.new
  end

  it "is valid given valid attributes" do
    @rating_question.attributes = valid_rating_question_attributes
    @rating_question.should be_valid
  end

  it "has 1 error on statement when statement is blank" do
    @rating_question.attributes = valid_rating_question_attributes.except(:statement)
    @rating_question.should have(1).error_on(:statement)
  end

end

describe RatingQuestion, ".type_as_string" do
  include RatingQuestionSpecHelpers
  
  before(:each) do
    @rating_question = RatingQuestion.new
  end
  
  it "returns the type formatted as a descriptive string" do
    @rating_question.attributes = valid_rating_question_attributes
    @rating_question.type_as_string.should eql("Rating")
  end
  
end

describe RatingQuestion, ".count" do
  
  it "returns a number indicating the count of question results with specified question id given a set of survey result ids"
  
end
