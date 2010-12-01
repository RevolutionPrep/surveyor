require 'spec_helper'

describe ReportsController do
  
  before(:each) do
    @survey = mock_model(Survey, :title => "title")
    @surveys = [@survey]
    @surveys.stub(:find).and_return(@survey)
    @user = mock_model(User, :surveys => @surveys)
    controller.stub(:current_user).and_return(@user)
  end
  
  it "retrieves the current_user" do
    controller.should_receive(:current_user).and_return(@user)
    get :index
  end

  describe "GET index" do
  
    it "finds all surveys belonging to the current_user" do
      @user.should_receive(:surveys).and_return(@surveys)
      get :index
    end
  
    it "assigns the surveys to @surveys" do
      get :index
      assigns[:surveys].should eql(@surveys)
    end
  
    it "renders the index template" do
      get :index
      response.should render_template(:index)
    end
  
  end

end