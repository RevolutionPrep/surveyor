require 'spec_helper'

describe Api::SurveysController do
  
  before(:each) do
    @survey = mock_model(Survey)
    @surveys = [@survey]
    @surveys.stub(:find_by_api_key).and_return(@survey)
    @user = mock_model(User, :surveys => @surveys)
    controller.stub(:current_user).and_return(@user)
  end
  
  it "finds the current user" do
    controller.should_receive(:current_user).and_return(@user)
    get :show, :version => "1_0", :id => 1
  end
  
  describe "GET show" do
    
    context "when the api version is 1.0" do
      
      before(:each) do
        @params = { :version => "1_0", :id => @survey.id.to_s, :format => "xml" }
      end
      
      it "finds the survey by api key" do
        @user.should_receive(:surveys).and_return(@surveys)
        @surveys.should_receive(:find_by_api_key).with(@params[:id]).and_return(@survey)
        get :show, @params
      end
      
      it "assigns the survey to @survey" do
        get :show, @params
        assigns[:survey].should eql(@survey)
      end
      
      context "when the survey is found" do
        
        before(:each) do
          @surveys.stub(:find_by_api_key).and_return(@survey)
        end
        
        it "renders the show template" do
          get :show, @params
          response.should render_template(:show)
        end
        
      end
      
      context "when the survey is not found" do
        
        before(:each) do
          @surveys.stub(:find_by_api_key).and_raise(ActiveRecord::RecordNotFound)
        end
        
        it "renders nothing" do
          get :show, @params
          response.should render_nothing
        end
        
        it "returns a status of 404" do
          get :show, @params
          response.should have_status(404)
        end
        
      end
      
    end
    
    context "when the api version is 1.1" do
      
      before(:each) do
        @params = { :version => "1_1", :id => @survey.id.to_s, :format => "xml" }
      end
      
      it "finds the survey by api key" do
        @user.should_receive(:surveys).and_return(@surveys)
        @surveys.should_receive(:find_by_api_key).with(@params[:id]).and_return(@survey)
        get :show, @params
      end
      
      it "assigns the survey to @survey" do
        get :show, @params
        assigns[:survey].should eql(@survey)
      end
      
      context "when the survey is found" do
        
        before(:each) do
          @surveys.stub(:find_by_api_key).and_return(@survey)
        end
        
        it "renders the show template" do
          get :show, @params
          response.should render_template(:show)
        end
        
      end
      
      context "when the survey is not found" do
        
        before(:each) do
          @surveys.stub(:find_by_api_key).and_raise(ActiveRecord::RecordNotFound)
        end
        
        it "renders nothing" do
          get :show, @params
          response.should render_nothing
        end
        
        it "returns a status of 404" do
          get :show, @params
          response.should have_status(404)
        end
        
      end
      
    end
    
    context "when the api version is not 1.0 or 1.1" do
      
      before(:each) do
        @params = { :version => "0_0", :id => 1, :format => "xml" }
      end
      
      it "renders nothing" do
        get :show, @params
        response.should render_nothing
      end
      
       it"returns a status of 405" do
         get :show, @params
         response.should have_status(405)
       end
      
    end
    
  end
  
end
