require 'spec_helper'

module QuestionResultSpecHelpers

  def valid_question_result_attributes
    {
      :survey_result_id => 1,
      :question_id      => 1,
      :component_id     => 1,
      :rating_label_id  => 1,
      :response         => "value for response"
    }
  end

end

describe QuestionResult do
  include QuestionResultSpecHelpers

  before(:each) do
    @question_result = QuestionResult.new
  end

  it "creates a new instance given valid attributes" do
    @question_result.attributes = valid_question_result_attributes
    @question_result.should be_valid
  end

end