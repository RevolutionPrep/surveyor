require 'spec_helper'

describe ResultsController do
  
  before(:each) do
    @survey = mock_model(Survey, :title => "title")
    @surveys = [@survey]
    @surveys.stub(:find).and_return(@survey)
    @survey_result = mock_model(SurveyResult)
    @survey_results = [@survey_result]
    @survey.stub(:survey_results).and_return(@survey_results)
    @user = mock_model(User, :surveys => @surveys)
    controller.stub(:current_user).and_return(@user)
  end
  
  it "retrieves the current_user" do
    controller.should_receive(:current_user).and_return(@user)
    get :index, :report_id => @survey.id
  end

  describe "GET index" do
    
    before(:each) do
      @params = { :report_id => @survey.id }
    end

    it "finds the survey belonging to the current_user" do
      @user.should_receive(:surveys).and_return(@surveys)
      @surveys.should_receive(:find).with(@params[:report_id]).and_return(@survey)
      get :index, @params
    end
  
    it "assigns the survey to @survey" do
      get :index, @params
      assigns[:survey].should eql(@survey)
    end
    
    it "finds all survey_results for this survey" do
      @survey.should_receive(:survey_results).and_return(@survey_results)
      get :index, @params
    end
    
    it "assigns the survey_results to @survey_results" do
      get :index, @params
      assigns[:survey_results].should eql(@survey_results)
    end
  
    it "renders the index template" do
      get :index, @params
      response.should render_template(:index)
    end
  
  end
  
end