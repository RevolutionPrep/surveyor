require 'spec_helper'

describe Api::SurveyResultsController do
  
  before(:each) do
    @question = mock_model(Question)
    @questions = [@question]
    @section = mock_model(Section, :questions => @questions)
    @sections = [@section]
    @survey = mock_model(Survey, :sections => @sections)
    @surveys = [@survey]
    @surveys.stub(:find_by_api_key).and_return(@survey)
    @question_result = mock_model(QuestionResult)
    @question_results = [@question_result]
    @question_results.stub(:find_all_by_question_id_and_survey_result_id).and_return(@question_results)
    @survey_result = mock_model(SurveyResult)
    @survey_result.stub(:build_results)
    @survey_result.stub(:save!)
    @survey_results = [@survey_result]
    @survey_results.stub(:find).and_return(@survey_result)
    @survey_results.stub(:build).and_return(@survey_result)
    @user = mock_model(User, :surveys => @surveys, :survey_results => @survey_results, :question_results => @question_results)
    controller.stub(:current_user).and_return(@user)
  end
  
  it "finds the current user" do
    controller.should_receive(:current_user).and_return(@user)
    get :index, :version => "1_0"
  end
  
  describe "GET index" do
    
    before(:each) do
      @params = { :api_key => "abcde", :results => "1", :format => "xml" }
    end
    
    context "when the api version is 1.0" do
      
      before(:each) do
        @params.merge!(:version => "1_0")
      end
      
      it "finds the survey by api key" do
        @user.should_receive(:surveys).and_return(@surveys)
        @surveys.should_receive(:find_by_api_key).with(@params[:api_key]).and_return(@survey)
        get :index, @params
      end
      
      it "assigns the survey to @survey" do
        get :index, @params
        assigns[:survey].should eql(@survey)
      end
      
      context "when the survey is found" do
        
        before(:each) do
          @surveys.stub(:find_by_api_key).and_return(@survey)
        end
        
        it "finds the questions in this survey" do
          @survey.should_receive(:sections).and_return(@sections)
          @section.should_receive(:questions).and_return(@questions)
          get :index, @params
        end
        
        it "assigns the questions to @questions" do
          get :index, @params
          assigns[:questions].should eql(@questions)
        end
        
        it "adds each question result by question_id and survey_result_id to @question_results" do
          @user.should_receive(:question_results).and_return(@question_results)
          @question_results.should_receive(:find_all_by_question_id_and_survey_result_id).with(@question.id, @params[:results])
          get :index, @params
        end
        
        it "renders the index template" do
          get :index, @params
          response.should render_template(:index)
        end
        
      end
      
      context "when the survey is not found" do
        
        before(:each) do
          @surveys.stub(:find_by_api_key).and_raise(ActiveRecord::RecordNotFound)
        end
        
        it "renders nothing" do
          get :index, @params
          response.should render_nothing
        end
        
        it "returns with a status of 404" do
          get :index, @params
          response.should have_status(404)
        end
        
      end
      
    end
    
    context "when the api version is 1.1" do
      
      before(:each) do
        @params.merge!(:version => "1_1")
      end
      
      it "finds the survey by api key" do
        @user.should_receive(:surveys).and_return(@surveys)
        @surveys.should_receive(:find_by_api_key).with(@params[:api_key]).and_return(@survey)
        get :index, @params
      end
      
      it "assigns the survey to @survey" do
        get :index, @params
        assigns[:survey].should eql(@survey)
      end
      
      context "when the survey is found" do
        
        before(:each) do
          @surveys.stub(:find_by_api_key).and_return(@survey)
        end
        
        it "finds the questions in this survey" do
          @survey.should_receive(:sections).and_return(@sections)
          @section.should_receive(:questions).and_return(@questions)
          get :index, @params
        end
        
        it "assigns the questions to @questions" do
          get :index, @params
          assigns[:questions].should eql(@questions)
        end
        
        it "adds each question result by question_id and survey_result_id to @question_results" do
          @user.should_receive(:question_results).and_return(@question_results)
          @question_results.should_receive(:find_all_by_question_id_and_survey_result_id).with(@question.id, @params[:results])
          get :index, @params
        end
        
        it "renders the index template" do
          get :index, @params
          response.should render_template(:index)
        end
        
      end
      
      context "when the survey is not found" do
        
        before(:each) do
          @surveys.stub(:find_by_api_key).and_raise(ActiveRecord::RecordNotFound)
        end
        
        it "renders nothing" do
          get :index, @params
          response.should render_nothing
        end
        
        it "returns with a status of 404" do
          get :index, @params
          response.should have_status(404)
        end
        
      end
      
    end
    
    context "when the api version is not 1.0 or 1.1" do
      
      before(:each) do
        @params.merge!(:version => "0_0")
      end
      
      it "renders nothing" do
        get :index, @params
        response.should render_nothing
      end
      
      it "returns with a status of 405" do
        get :index, @params
        response.should have_status(405)
      end
      
    end
    
  end
  
  describe "GET show" do
    
    before(:each) do
      @params = { :id => @survey_result.id.to_s, :format => "xml" }
    end
    
    context "when the api version is 1.0" do
      
      before(:each) do
        @params.merge!(:version => "1_0")
      end
      
      it "finds the survey result" do
        @user.should_receive(:survey_results).and_return(@survey_results)
        @survey_results.should_receive(:find).with(@params[:id]).and_return(@survey_result)
        get :show, @params
      end
      
      it "assigns the survey result to @survey_result" do
        get :show, @params
        assigns[:survey_result].should eql(@survey_result)
      end
      
      context "when the survey result is found" do
        
        before(:each) do
          @survey_results.stub(:find).and_return(@survey_result)
        end
        
        it "renders the show template" do
          get :show, @params
          response.should render_template(:show)
        end
        
      end
      
      context "when the survey result is not found" do
        
        before(:each) do
          @survey_results.stub(:find).and_raise(ActiveRecord::RecordNotFound)
        end
        
        it "renders nothing" do
          get :show, @params
          response.should render_nothing
        end
        
        it "returns with a status of 404" do
          get :show, @params
          response.should have_status(404)
        end
        
      end
      
    end
    
    context "when the api version is 1.1" do
      
      before(:each) do
        @params.merge!(:version => "1_1")
      end
      
      it "finds the survey result" do
        @user.should_receive(:survey_results).and_return(@survey_results)
        @survey_results.should_receive(:find).with(@params[:id]).and_return(@survey_result)
        get :show, @params
      end
      
      it "assigns the survey result to @survey_result" do
        get :show, @params
        assigns[:survey_result].should eql(@survey_result)
      end
      
      context "when the survey result is found" do
        
        before(:each) do
          @survey_results.stub(:find).and_return(@survey_result)
        end
        
        it "renders the show template" do
          get :show, @params
          response.should render_template(:show)
        end
        
      end
      
      context "when the survey result is not found" do
        
        before(:each) do
          @survey_results.stub(:find).and_raise(ActiveRecord::RecordNotFound)
        end
        
        it "renders nothing" do
          get :show, @params
          response.should render_nothing
        end
        
        it "returns with a status of 404" do
          get :show, @params
          response.should have_status(404)
        end
        
      end
      
    end
    
    context "when the api version is not 1.0 or 1.1" do
      
      before(:each) do
        @params.merge!(:version => "0_0")
      end
      
      it "renders nothing" do
        get :show, @params
        response.should render_nothing
      end
      
      it "returns with a status of 405" do
        get :show, @params
        response.should have_status(405)
      end
      
    end
    
  end
  
  describe "POST create" do
    
    before(:each) do
      @params = { :survey_result => { "key" => "abcde" }, :format => "xml" }
    end
    
    context "when the api version is 1.0" do
      
      before(:each) do
        @params.merge!(:version => "1_0")
      end
      
      it "finds the survey by api key" do
        @user.should_receive(:surveys).and_return(@surveys)
        @surveys.should_receive(:find_by_api_key).with(@params[:survey_result]["key"]).and_return(@survey)
        post :create, @params
      end
      
      it "assigns the survey to @survey" do
        post :create, @params
        assigns[:survey].should eql(@survey)
      end
      
      context "when the survey is found" do
        
        before(:each) do
          @surveys.stub(:find_by_api_key).and_return(@survey)
        end
        
        it "creates a new survey result" do
          @user.should_receive(:survey_results).and_return(@survey_results)
          @survey_results.should_receive(:build).with(:survey_id => @survey.id, :completed => true)
          post :create, @params
        end
        
        it "builds the result with params[:survey_result]" do
          @survey_result.should_receive(:build_results).with(@params[:survey_result]).and_return(@survey_result)
          post :create, @params
        end
        
        it "saves the survey result" do
          @survey_result.should_receive(:save!)
          post :create, @params
        end
        
        context "when the build and save is successful" do
          
          it "renders the create template" do
            post :create, @params
            response.should render_template(:create)
          end
          
        end
        
        context "when the build or save is unsuccessful" do
          
          before(:each) do
            @survey_result.stub(:save!).and_raise(StandardError)
          end
          
          it "renders nothing" do
            post :create, @params
            response.should render_nothing
          end
          
          it "returns with a status of 500" do
            post :create, @params
            response.should have_status(500)
          end
          
        end
        
      end
      
      context "when the survey is not found" do
        
        before(:each) do
          @surveys.stub(:find_by_api_key).and_raise(ActiveRecord::RecordNotFound)
        end
        
        it "renders nothing" do
          post :create, @params
          response.should render_nothing
        end
        
        it "returns with a status of 404" do
          post :create, @params
          response.should have_status(404)
        end
        
      end
      
    end
    
    context "when the api version is 1.1" do
      
      before(:each) do
        @params.merge!(:version => "1_1")
      end
      
      it "finds the survey by api key" do
        @user.should_receive(:surveys).and_return(@surveys)
        @surveys.should_receive(:find_by_api_key).with(@params[:survey_result]["key"]).and_return(@survey)
        post :create, @params
      end
      
      it "assigns the survey to @survey" do
        post :create, @params
        assigns[:survey].should eql(@survey)
      end
      
      context "when the survey is found" do
        
        before(:each) do
          @surveys.stub(:find_by_api_key).and_return(@survey)
        end
        
        it "creates a new survey result" do
          @user.should_receive(:survey_results).and_return(@survey_results)
          @survey_results.should_receive(:build).with(:survey_id => @survey.id, :completed => true)
          post :create, @params
        end
        
        it "builds the result with params[:survey_result]" do
          @survey_result.should_receive(:build_results).with(@params[:survey_result]).and_return(@survey_result)
          post :create, @params
        end
        
        it "saves the survey result" do
          @survey_result.should_receive(:save!)
          post :create, @params
        end
        
        context "when the build and save is successful" do
          
          it "renders the create template" do
            post :create, @params
            response.should render_template(:create)
          end
          
        end
        
        context "when the build or save is unsuccessful" do
          
          before(:each) do
            @survey_result.stub(:save!).and_raise(StandardError)
          end
          
          it "renders nothing" do
            post :create, @params
            response.should render_nothing
          end
          
          it "returns with a status of 500" do
            post :create, @params
            response.should have_status(500)
          end
          
        end
        
      end
      
      context "when the survey is not found" do
        
        before(:each) do
          @surveys.stub(:find_by_api_key).and_raise(ActiveRecord::RecordNotFound)
        end
        
        it "renders nothing" do
          post :create, @params
          response.should render_nothing
        end
        
        it "returns with a status of 404" do
          post :create, @params
          response.should have_status(404)
        end
        
      end
      
    end
    
    context "when the api version is not 1.0 or 1.1" do
      
      before(:each) do
        @params.merge!(:version => "0_0")
      end
      
      it "renders nothing" do
        post :create, @params
        response.should render_nothing
      end
      
      it "returns with a status of 405" do
        post :create, @params
        response.should have_status(405)
      end
      
    end
    
  end
  
end