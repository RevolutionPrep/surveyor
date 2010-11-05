require 'spec_helper'

describe Api::QuestionResultsController do
  
  before(:each) do
    @question_result = mock_model(QuestionResult)
    @question_results = [@question_result]
    @question_results.stub(:find_all_by_question_id_and_survey_result_id).and_return(@question_results)
    @survey_result = mock_model(SurveyResult)
    @question = mock_model(Question, :question_results => @question_results)
    @questions = [@question]
    @questions.stub(:find_all_by_handle).and_return(@questions)
    @section = mock_model(Section, :questions => @questions)
    @sections = [@section]
    @survey = mock_model(Survey, :sections => @sections)
    @surveys = [@survey]
    @surveys.stub(:find_by_api_key).and_return(@survey)
    @user = mock_model(User, :surveys => @surveys, :question_results => @question_results)
    controller.stub(:current_user).and_return(@user)
  end
  
  it "finds the current user" do
    controller.should_receive(:current_user).and_return(@user)
    get :show, :version => "1_0", :id => @question_result.id.to_s, :api_key => "abcde"
  end
  
  describe "GET show" do
    
    before(:each) do
      @params = { :version => "1_0", :id => @question_result.id.to_s, :handles => ["handle"], :results => [@survey_result.id.to_s], :api_key => "abcde", :format => "xml" }
    end
    
    it "checks to see if the request is a POST" do
      controller.request.should_receive(:post?)
      get :show, @params
    end
    
    context "when the api version is 1.1" do
      
      before(:each) do
        @params.merge!(:version => "1_1")
      end
      
      it "finds the survey by api key" do
        @user.should_receive(:surveys).and_return(@surveys)
        @surveys.should_receive(:find_by_api_key).with(@params[:api_key]).and_return(@survey)
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
      
        it "finds all questions with the given handles" do
          @survey.should_receive(:sections).and_return(@sections)
          @section.should_receive(:questions).and_return(@questions)
          @questions.should_receive(:find_all_by_handle).with(@params[:handles]).and_return(@questions)
          get :show, @params
        end
      
        it "assigns the questions to @questions" do
          get :show, @params
          assigns[:questions].should eql(@questions)
        end
      
        it "finds all the question results for each question by survey result id" do
          @user.should_receive(:question_results).and_return(@question_results)
          @question_results.should_receive(:find_all_by_question_id_and_survey_result_id).with(@question.id, @params[:results])
          get :show, @params
        end
      
        it "assigns the question results to @question_results" do
          get :show, @params
          assigns[:question_results].should eql([@question_results])
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
        
        it "returns with a status of 404" do
          get :show, @params
          response.should have_status(404)
        end
        
      end
      
    end
    
    context "when the api version is not 1.1" do
      
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
  
  describe "POST show" do
    
    before(:each) do
      @params = { :id => @question_result.id.to_s, :version => "1_1", :hash => { :api_key => "abcde", :handles => "handle1,handle2" }, :format => "xml" }
      @question_counts = [1]
      @short_answer_results = ["answer"]
      QuestionResultReporter.stub(:build).and_return([@question_results, @question_counts, @short_answer_results])
    end
    
    it "checks to see if the request is a POST" do
      controller.request.should_receive(:post?)
      post :show, @params
    end
    
    context "when the api version is 1.1" do
      
      before(:each) do
        @params.merge!(:version => "1_1")
      end
      
      it "finds the survey by api key" do
        @user.should_receive(:surveys).and_return(@surveys)
        @surveys.should_receive(:find_by_api_key).and_return(@survey)
        post :show, @params
      end
      
      it "assigns the survey to @survey" do
        post :show, @params
        assigns[:survey].should eql(@survey)
      end
      
      context "when the survey is found" do
        
        before(:each) do
           @surveys.stub(:find_by_api_key).and_return(@survey)
        end
        
        it "finds the questions by their handles" do
          @survey.should_receive(:sections).and_return(@sections)
          @section.should_receive(:questions).and_return(@questions)
          @questions.should_receive(:find_all_by_handle).with(@params[:hash][:handles].split(","))
          post :show, @params
        end
        
        it "assigns the questions to @questions" do
          post :show, @params
          assigns[:questions].should eql(@questions)
        end
        
        it "builds a question result report" do
          QuestionResultReporter.should_receive(:build)
          post :show, @params
        end
        
        it "assigns the question results to @question_results" do
          post :show, @params
          assigns[:question_results].should eql(@question_results)
        end
        
        it "assigns the question counts to @question_counts" do
          post :show, @params
          assigns[:question_counts].should eql(@question_counts)
        end
        
        it "assigns the short answer results to @short_answer_results" do
          post :show, @params
          assigns[:short_answer_results].should eql(@short_answer_results)
        end
        
        it "renders the show template" do
          post :show, @params
          response.should render_template(:show)
        end
        
      end
      
      context "when the survey is not found" do
        
        before(:each) do
          @surveys.stub(:find_by_api_key).and_raise(ActiveRecord::RecordNotFound)
        end
        
        it "renders nothing" do
          post :show, @params
          response.should render_nothing
        end
        
        it "returns with a status of 404" do
          post :show, @params
          response.should have_status(404)
        end
        
      end
      
    end
    
    context "when the api version is not 1.1" do
      
      before(:each) do
        @params.merge!(:version => "0_0")
      end
      
      it "renders nothing" do
        post :show, @params
        response.should render_nothing
      end
      
      it "returns with a status of 405" do
        post :show, @params
        response.should have_status(405)
      end
      
    end
    
  end
  
  describe "GET headcount" do
    
    before(:each) do
      @params = { :version => "1_1", :api_key => "abcde", :handle => "handle", :choice => "choice", :results => @question_results.collect(&:id), :format => "xml" }
      @questions.stub(:find_by_handle).and_return(@question)
      @component = mock_model(Component)
      @components = [@component]
      @rating_label = mock_model(RatingLabel)
      @rating_labels = [@rating_label]
      @rating_scale = mock_model(RatingScale, :rating_labels => @rating_labels)
      @question.stub(:components).and_return(@components)
      @question.stub(:rating_labels).and_return(@rating_labels)
    end
    
    context "when the api version is 1.1" do
      
      before(:each) do
        @params.merge!(:version => "1_1")
      end
      
      it "finds the survey by api key" do
        @user.should_receive(:surveys).and_return(@surveys)
        @surveys.should_receive(:find_by_api_key).with(@params[:api_key]).and_return(@survey)
        get :headcount, @params
      end
      
      it "assigns the survey to @survey" do
        get :headcount, @params
        assigns[:survey].should eql(@survey)
      end
      
      context "when the survey is found" do
        
        before(:each) do
          @surveys.stub(:find_by_api_key).and_return(@survey)
        end
        
        it "finds the question by its handle" do
          @survey.should_receive(:sections).and_return(@sections)
          @section.should_receive(:questions).and_return(@questions)
          @questions.should_receive(:find_by_handle).with(@params[:handle]).and_return(@question)
          get :headcount, @params
        end
        
        context "when the question is found" do
          
          before(:each) do
            @questions.stub(:find_by_handle).and_return(@question)
          end
          
          context "when the question is a MultipleChoiceQuestion" do
            
            before(:each) do
              @question = mock_model(MultipleChoiceQuestion)
              @questions.stub(:find_by_handle).and_return(@question)
              @question_results.stub(:find_all_by_question_id_and_component_id_and_survey_result_id).and_return(@question_results)
            end
            
            it "finds the component by value" do
              @question.should_receive(:components).and_return(@components)
              @components.should_receive(:find_by_value).with(@params[:choice]).and_return(@component)
              get :headcount, @params
            end
            
            context "when the component is found" do
              
              before(:each) do
                @question.stub(:components).and_return(@components)
                @components.stub(:find_by_value).and_return(@component)
              end
              
              it "finds the question results with this question id, component id, and survey result ids" do
                @question_results.should_receive(:find_all_by_question_id_and_component_id_and_survey_result_id).with(@question.id, @component.id, @params[:results]).and_return(@question_results)
                get :headcount, @params
              end
              
              it "assigns the question results to @question_results" do
                get :headcount, @params
                assigns[:question_results].should eql(@question_results)
              end
              
            end
            
            context "when the component is not found" do
              
              before(:each) do
                @question.stub(:components).and_return(@components)
                @components.stub(:find_by_value).and_raise(ActiveRecord::RecordNotFound)
              end
              
              it "renders nothing" do
                get :headcount, @params
                response.should render_nothing
              end
              
              it "returns with a status of 404" do
                get :headcount, @params
                response.should have_status(404)
              end
              
            end
            
          end
          
          context "when the question is a RatingQuestion" do
            
            before(:each) do
              @question = mock_model(RatingQuestion, :rating_scale => @rating_scale)
              @questions.stub(:find_by_handle).and_return(@question)
              @question_results.stub(:find_all_by_question_id_and_rating_label_id_and_survey_result_id).and_return(@question_results)
              @question.stub(:rating_scale).and_return(@rating_scale)
              @rating_scale.stub(:rating_labels).and_return(@rating_labels)
              @rating_labels.stub(:find_by_key).and_return(@rating_label)
            end
            
            it "finds the rating label by key" do
              @question.should_receive(:rating_scale).and_return(@rating_scale)
              @rating_scale.should_receive(:rating_labels).and_return(@rating_labels)
              @rating_labels.should_receive(:find_by_key).with(@params[:choice]).and_return(@rating_label)
              get :headcount, @params
            end
            
            it "assigns the rating label to @rating_label" do
              get :headcount, @params
              assigns[:rating_label].should eql(@rating_label)
            end
            
            context "when the rating label is found" do
              
              before(:each) do
                @rating_labels.stub(:find_by_key).and_return(@rating_label)
              end
              
              it "finds the question results with this question id, rating label id, and survey result ids" do
                @question_results.should_receive(:find_all_by_question_id_and_rating_label_id_and_survey_result_id).with(@question.id, @rating_label.id, @params[:results]).and_return(@question_results)
                get :headcount, @params
              end
              
              it "assigns the question results to @question_results" do
                get :headcount, @params
                assigns[:question_results].should eql(@question_results)
              end
              
            end
            
            context "when the rating label is not found" do
              
              before(:each) do
                @rating_labels.stub(:find_by_key).and_raise(ActiveRecord::RecordNotFound)
              end
              
              it "renders nothing" do
                get :headcount, @params
                response.should render_nothing
              end
              
              it "returns with a status of 404" do
                get :headcount, @params
                response.should have_status(404)
              end
              
            end
            
          end
          
        end
        
        context "when the question is not found" do
          
          before(:each) do
            @questions.stub(:find_by_handle).and_raise(ActiveRecord::RecordNotFound)
          end
          
          it "renders nothing" do
            get :headcount, @params
            response.should render_nothing
          end
          
          it "returns with a status of 404" do
            get :headcount, @params
            response.should have_status(404)
          end
          
        end
        
        it "finds the question results with this question id and survey result ids" do
          @user.should_receive(:question_results).and_return(@question_results)
          @question_results.should_receive(:find_all_by_question_id_and_survey_result_id).with(@question.id, @params[:results]).and_return(@question_results)
          get :headcount, @params
        end
        
        it "assigns the question results to @total_results" do
          get :headcount, @params
          assigns[:total_results].should eql(@question_results)
        end
        
        it "renders the headcount template" do
          get :headcount, @params
          response.should render_template(:headcount)
        end
        
      end
      
      context "when the survey is not found" do
        
        before(:each) do
          @surveys.stub(:find_by_api_key).and_raise(ActiveRecord::RecordNotFound)
        end
        
        it "renders nothing" do
          get :headcount, @params
          response.should render_nothing
        end
        
        it "returns with a status of 404" do
          get :headcount, @params
          response.should have_status(404)
        end
        
      end
      
    end
    
    context "when the api version is not 1.1" do
      
      before(:each) do
        @params.merge!(:version => "0_0")
      end
      
      it "renders nothing" do
        get :headcount, @params
        response.should render_nothing
      end
      
      it "returns with a status of 405" do
        get :headcount, @params
        response.should have_status(405)
      end
      
    end
    
  end
  
  describe "GET gpa" do
    
    before(:each) do
      @params = { :api_key => "abcde", :handle => "handle", :results => @question_results.collect(&:id), :format => "xml" }
    end
    
    context "when the api version is 1.1" do
      
      before(:each) do
        @params.merge!(:version => "1_1")
      end
      
      it "finds the survey by api key" do
        @user.should_receive(:surveys).and_return(@surveys)
        @surveys.should_receive(:find_by_api_key).with(@params[:api_key]).and_return(@survey)
        get :gpa, @params
      end
      
      it "assigns the survey to @survey" do
        get :gpa, @params
        assigns[:survey].should eql(@survey)
      end
      
      context "when the survey is found" do
        
        before(:each) do
          @surveys.stub(:find_by_api_key).and_return(@survey)
          @survey.stub(:sections).and_return(@sections)
          @section.stub(:questions).and_return(@questions)
          @questions.stub(:find_by_handle).and_return(@question)
        end
        
        it "finds the question by handle" do
          @survey.should_receive(:sections).and_return(@sections)
          @section.should_receive(:questions).and_return(@questions)
          @questions.should_receive(:find_by_handle).with(@params[:handle]).and_return(@question)
          get :gpa, @params
        end
        
        it "assigns the question to @question" do
          get :gpa, @params
          assigns[:question].should eql(@question)
        end
        
        context "when the question is found" do
          
          before(:each) do
            @questions.stub(:find_by_handle).and_return(@question)
          end
          
          it "finds question results by question id and survey result id" do
            @user.should_receive(:question_results).and_return(@question_results)
            @question_results.should_receive(:find_all_by_question_id_and_survey_result_id).with(@question.id, @params[:results]).and_return(@question_results)
            get :gpa, @params
          end
          
          it "assigns the question results to @question_results" do
            get :gpa, @params
            assigns[:question_results].should eql(@question_results)
          end
          
          it "renders the gpa template" do
            get :gpa, @params
            response.should render_template(:gpa)
          end
          
        end
        
        context "when the question is not found" do
          
          before(:each) do
            @questions.stub(:find_by_handle).and_raise(ActiveRecord::RecordNotFound)
          end
          
          it "renders nothing" do
            get :gpa, @params
            response.should render_nothing
          end
          
          it "returns a status of 404" do
            get :gpa, @params
            response.should have_status(404)
          end
          
        end
        
      end
      
      context "when the survey is not found" do
        
        before(:each) do
          @surveys.stub(:find_by_api_key).and_raise(ActiveRecord::RecordNotFound)
        end
        
        it "renders nothing" do
          get :gpa, @params
          response.should render_nothing
        end
        
        it "returns a status of 404" do
          get :gpa, @params
          response.should have_status(404)
        end
        
      end
      
    end
    
    context "when the api version is not 1.1" do
      
      before(:each) do
        @params.merge!(:version => "0_0")
      end
      
      it "renders nothing" do
        get :gpa, @params
        response.should render_nothing
      end
      
      it "returns a status of 405" do
        get :gpa, @params
        response.should have_status(405)
      end
      
    end
    
  end
  
end
