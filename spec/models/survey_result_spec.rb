require 'spec_helper'

module SurveyResultSpecHelpers

  def valid_survey_result_attributes
    {
      :survey => mock_model(Survey),
      :user   => mock_model(User)
    }
  end

end

describe SurveyResult do
  include SurveyResultSpecHelpers

  before(:each) do
    @survey_result = SurveyResult.new
  end

  it "is valid given valid attributes" do
    @survey_result.attributes = valid_survey_result_attributes
    @survey_result.should be_valid
  end

end

describe SurveyResult, ".question_results_attributes=(attributes)" do
  include SurveyResultSpecHelpers
  
  before(:each) do
    @survey_result = SurveyResult.new(valid_survey_result_attributes)
  end
  
  it "builds a question result with component_id and response when the question referenced is a MultipleChoiceQuestion" do
    @question = mock_model(MultipleChoiceQuestion)
    @survey_result.question_results_attributes = [ [ @question.id, { :type => @question.class.to_s, :component_id => 1, :response => "response" } ] ]
    @survey_result.question_results.length.should eql(1)
    @survey_result.question_results[0].component_id.should eql(1)
    @survey_result.question_results[0].response.should eql("response")
  end
  
  it "builds a question result with rating_label_id when the question referenced is a RatingQuestion" do
    @question = mock_model(RatingQuestion)
    @survey_result.question_results_attributes = [ [ @question.id, { :type => @question.class.to_s, :rating_label_id => 1 } ] ]
    @survey_result.question_results.length.should eql(1)
    @survey_result.question_results[0].rating_label_id.should eql(1)
  end
  
  it "builds a question result with response when the question referenced is a ShortAnswerQuestion" do
    @question = mock_model(ShortAnswerQuestion)
    @survey_result.question_results_attributes = [ [ @question.id, { :type => @question.class.to_s, :response => "response" } ] ]
    @survey_result.question_results.length.should eql(1)
    @survey_result.question_results[0].response.should eql("response")
  end

end

describe SurveyResult, ".save_question_results" do
  include SurveyResultSpecHelpers
  
  before(:each) do
    @survey_result = SurveyResult.new(valid_survey_result_attributes)
  end
  
  it "saves question results associated to this survey result" do
    @survey_result.question_results.build(:response => "response")
    @survey_result.question_results.build(:rating_label_id => 4)
    @survey_result.save_question_results
    @survey_result.question_results.length.should eql(2)
    @survey_result.question_results[0].response.should eql("response")
    @survey_result.question_results[1].rating_label_id.should eql(4)
  end
  
end

describe SurveyResult, ".build_results(results)" do
  
end