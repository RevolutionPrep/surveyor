require 'spec_helper'

describe SurveysController do
  
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
  
  context "when the survey is not found" do
    
    before(:each) do
      @surveys.stub(:find).and_raise(ActiveRecord::RecordNotFound)
    end
    
    it "sets the flash message" do
      get :show, :id => 1
      flash[:notice].should eql("You do not have access to this asset.")
    end
    
    it "redirects to root_url" do
      get :show, :id => 1
      response.should redirect_to(root_url)
    end
    
  end
  
  context "when the survey is found" do

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
  
    describe "GET show" do
    
      before(:each) do
        @params = { :id => @survey.id.to_s }
        @surveys.stub(:find).and_return(@survey)
      end
    
      it "finds the survey with params[:id]" do
        @surveys.should_receive(:find).with(@params[:id]).and_return(@survey)
        get :show, @params
      end
    
      it "assigns the found survey to @survey" do
        get :show, @params
        assigns[:survey].should eql(@survey)
      end
    
      it "assigns the survey as @breadcrumb" do
        get :show, @params
        assigns[:breadcrumb].should eql(@survey)
      end
    
      it "renders the show template" do
        get :show, @params
        response.should render_template(:show)
      end
    
    end
  
    describe "GET new" do
    
      before(:each) do
        @surveys.stub(:new).and_return(@survey)
      end
    
      it "creates a new survey" do
        @surveys.should_receive(:new).and_return(@survey)
        get :new
      end
    
      it "assigns the new survey to @survey" do
        get :new
        assigns[:survey].should eql(@survey)
      end
    
      it "renders the new template" do
        get :new
        response.should render_template(:new)
      end
    
    end
  
    describe "GET edit" do
    
      before(:each) do
        @params = { :id => @survey.id.to_s }
        @surveys.stub(:find).and_return(@survey)
      end
    
      it "finds the survey with params[:id]" do
        @surveys.should_receive(:find).with(@params[:id]).and_return(@survey)
        get :edit, @params
      end
    
      it "assigns the found survey to @survey" do
        get :edit, @params
        assigns[:survey].should eql(@survey)
      end
    
      it "assigns the survey as @breadcrumb" do
        get :edit, @params
        assigns[:breadcrumb].should eql(@survey)
      end
    
      it "renders the edit template" do
        get :edit, @params
        response.should render_template(:edit)
      end
    
    end
  
    describe "POST create" do
    
      before(:each) do
        @params = { :survey => { "title" => "title" } }
        @surveys.stub(:build).and_return(@survey)
        @survey.stub(:save)
      end
    
      it "creates a new survey with params[:survey]" do
        @surveys.should_receive(:build).with(@params[:survey]).and_return(@survey)
        post :create, @params
      end
    
      it "assigns the new survey to @survey" do
        post :create, @params
        assigns[:survey].should eql(@survey)
      end
    
      it "saves the new survey" do
        @survey.should_receive(:save)
        post :create, @params
      end
    
      context "when the save is successful" do
      
        before(:each) do
          @survey.stub(:save).and_return(true)
        end
      
        it "sets the flash message" do
          post :create, @params
          flash[:notice].should eql("title created.")
        end
      
        it "redirects to the survey_path for @survey" do
          post :create, @params
          response.should redirect_to(survey_path(@survey))
        end
      
      end
    
      context "when the save is unsuccessful" do
      
        before(:each) do
          @survey.stub(:save).and_return(false)
        end
      
        it "renders the new template" do
          post :create, @params
          response.should render_template(:new)
        end
      
      end
    
    end
  
    describe "PUT update" do
    
      before(:each) do
        @params = { :id => @survey.id.to_s, :survey => { "title" => "title" } }
        @surveys.stub(:find).and_return(@survey)
        @survey.stub(:update_attributes)
      end
    
      it "finds the survey with params[:id]" do
        @surveys.should_receive(:find).with(@params[:id])
        put :update, @params
      end
    
      it "assigns the found survey to @survey" do
        put :update, @params
        assigns[:survey].should eql(@survey)
      end
    
      it "assigns the survey to @breadcrumb" do
        put :update, @params
        assigns[:breadcrumb].should eql(@survey)
      end
    
      it "updates the survey record with params[:survey]" do
        @survey.should_receive(:update_attributes).with(@params[:survey])
        put :update, @params
      end
    
      context "when the update is successful" do
      
        before(:each) do
          @survey.stub(:update_attributes).and_return(true)
        end
      
        it "sets the flash message" do
          put :update, @params
          flash[:notice].should eql("title updated.")
        end
      
        it "redirects to the survey path for @survey" do
          put :update, @params
          response.should redirect_to(survey_path(@survey))
        end
      
      end
    
      context "when the update is unsuccessful" do
      
        before(:each) do
          @survey.stub(:update_attributes).and_return(false)
        end
      
        it "renders the edit template" do
          put :update, @params
          response.should render_template(:edit)
        end
      
      end
    
    end
  
    describe "DELETE destroy" do
    
      before(:each) do
        @params = { :id => @survey.id.to_s }
        @surveys.stub(:find).and_return(@survey)
        @survey.stub(:destroy)
      end
    
      it "finds the survey with params[:id]" do
        @surveys.should_receive(:find).with(@params[:id]).and_return(@survey)
        delete :destroy, @params
      end
    
      it "assigns the found survey to @survey" do
        delete :destroy, @params
        assigns[:survey].should eql(@survey)
      end
    
      it "destroys the survey" do
        @survey.should_receive(:destroy)
        delete :destroy, @params
      end
    
      it "sets the flash message" do
        delete :destroy, @params
        flash[:notice].should eql("Survey deleted.")
      end
    
      it "redirects to the surveys path" do
        delete :destroy, @params
        response.should redirect_to(surveys_path)
      end
    
    end
  
    describe "GET confirm_delete" do
    
      before(:each) do
        @params = { :id => @survey.id.to_s }
        @surveys.stub(:find).and_return(@survey)
      end
    
      it "finds the survey with params[:id]" do
        @surveys.should_receive(:find).with(@params[:id]).and_return(@survey)
        get :confirm_delete, @params
      end
    
      it "assigns the found survey to @survey" do
        get :confirm_delete, @params
        assigns[:survey].should eql(@survey)
      end
    
      it "assigns the survey to @breadcrumb" do
        get :confirm_delete, @params
        assigns[:breadcrumb].should eql(@survey)
      end
    
      it "renders the confirm_delete template" do
        get :confirm_delete, @params
        response.should render_template(:confirm_delete)
      end
    
    end
  
  end

end
