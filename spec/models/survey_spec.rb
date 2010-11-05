require 'spec_helper'

module SurveySpecHelpers

  def valid_survey_attributes
    {
      :title => "Survey Title",
      :description => "Survey Description",
      :user => mock_model(User)
    }
  end

end

describe Survey, "validations" do
  include SurveySpecHelpers

  before(:each) do
    @survey = Survey.new
  end

  it "is valid given valid attributes" do
    @survey.attributes = valid_survey_attributes
    @survey.should be_valid
  end
  
  it "has an error on title when title is blank" do
    @survey.attributes = valid_survey_attributes.except(:title)
    @survey.should_not be_valid
    @survey.should have(1).error_on(:title)
  end

end

describe Survey, ".generate_api_key" do
  include SurveySpecHelpers
  
  before(:each) do
    @survey_1 = Survey.new
    @survey_2 = Survey.new
    @survey_1.attributes = valid_survey_attributes
    @survey_1.attributes = valid_survey_attributes
    @survey_2.attributes = valid_survey_attributes
  end

  it "generates a random key that is 5 characters long" do
    @survey_1.generate_api_key.length.should eql(5)
  end

  it "generates a unique key at the scope of the user this survey belongs to" do
    @survey_1.generate_api_key
    @survey_2.generate_api_key.should_not eql(@survey_1.api_key)
  end
  
end

describe Survey, ".breadcrumb_parent" do
  include SurveySpecHelpers
  
  before(:each) do
    @survey = Survey.new(valid_survey_attributes)
  end
  
  it "returns nil" do
    @survey.breadcrumb_parent.should eql(nil)
  end

end

describe Survey, ".breadcrumb_title" do
  include SurveySpecHelpers
  
  before(:each) do
    @survey = Survey.new(valid_survey_attributes)
  end
  
  it "returns the title of this survey" do
    @survey.breadcrumb_title.should eql(@survey.title)
  end
  
end