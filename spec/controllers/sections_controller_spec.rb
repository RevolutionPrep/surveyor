require 'spec_helper'

describe SectionsController do

  before(:each) do
    @section = mock_model(Section)
    @section.stub(:save)
    @sections = [@section]
    @sections.stub(:find).and_return(@section)
    @survey = mock_model(Survey, :sections => @sections)
    @surveys = [@surveys]
    @surveys.stub(:find).and_return(@survey)
    @user = mock_model(User, :surveys => @surveys, :sections => @sections)
    controller.stub(:current_user).and_return(@user)
  end

  it "retrieves the current user" do
    controller.should_receive(:current_user).and_return(@user)
    get :index, :survey_id => @survey.id
  end
  
  context "when the survey is not found" do
    
    before(:each) do
      @surveys.stub(:find).and_raise(ActiveRecord::RecordNotFound)
    end
    
    it "sets the flash message" do
      get :index, :survey_id => 1
      flash[:notice].should eql("You do not have access to this asset.")
    end
    
    it "redirects to root_url" do
      get :index, :survey_id => 1
      response.should redirect_to(root_url)
    end
    
  end
  
  context "when the section is not found" do
    
    before(:each) do
      @sections.stub(:find).and_raise(ActiveRecord::RecordNotFound)
    end
    
    it "sets the flash message" do
      get :show, :survey_id => 1, :id => 1
      flash[:notice].should eql("You do not have access to this asset.")
    end
    
    it "redirects to root_url" do
      get :show, :survey_id => 1, :id => 1
      response.should redirect_to(root_url)
    end
    
  end
  
  describe "GET index" do
    
    before(:each) do
      @params = { :survey_id => @survey.id.to_s }
    end
    
    it "finds the survey containing the sections" do
      @user.should_receive(:surveys).and_return(@surveys)
      @surveys.should_receive(:find).with(@params[:survey_id]).and_return(@survey)
      get :index, @params
    end
    
    it "assigns the survey to @survey" do
      get :index, @params
      assigns[:survey].should eql(@survey)
    end
    
    it "finds the sections in this survey" do
      @survey.should_receive(:sections).and_return(@sections)
      get :index, @params
    end
    
    it "assigns the sections to @sections" do
      get :index, @params
      assigns[:sections].should eql(@sections)
    end
    
    it "assigns @survey to @breadcrumb" do
      get :index, @params
      assigns[:breadcrumb].should eql(@survey)
    end
    
    it "renders the index template" do
      get :index, @params
      response.should render_template(:index)
    end
    
  end
  
  describe "GET show" do
    
    before(:each) do
      @params = { :id => @section.id.to_s }
    end
    
    it "finds the section" do
      @user.should_receive(:sections).and_return(@sections)
      @sections.should_receive(:find).with(@params[:id]).and_return(@section)
      get :show, @params
    end
    
    it "assigns the section to @section" do
      get :show, @params
      assigns[:section].should eql(@section)
    end
    
    it "assigns @section to @breadcrumb" do
      get :show, @params
      assigns[:breadcrumb].should eql(@section)
    end
    
    it "renders the show template" do
      get :show, @params
      response.should render_template(:show)
    end
    
  end
  
  describe "GET new" do
    
    before(:each) do
      @params = { :survey_id => @survey.id.to_s }
      @sections.stub(:new).and_return(@section)
    end
    
    it "finds the survey into which a new section will be added" do
      @user.should_receive(:surveys).and_return(@surveys)
      @surveys.should_receive(:find).with(@params[:survey_id]).and_return(@survey)
      get :new, @params
    end
    
    it "assigns the survey to @survey" do
      get :new, @params
      assigns[:survey].should eql(@survey)
    end
    
    it "creates a new section within the survey" do
      @sections.should_receive(:new).and_return(@section)
      get :new, @params
    end
    
    it "assigns the new section to @section" do
      get :new, @params
      assigns[:section].should eql(@section)
    end
    
    it "assigns @section to @breadcrumb" do
      get :new, @params
      assigns[:breadcrumb].should eql(@section)
    end
    
    it "renders the new template" do
      get :new, @params
      response.should render_template(:new)
    end
    
  end
  
  describe "GET edit" do
    
    before(:each) do
      @params = { :id => @section.id.to_s }
    end
    
    it "finds the section" do
      @user.should_receive(:sections).and_return(@sections)
      @sections.should_receive(:find).with(@params[:id]).and_return(@section)
      get :edit, @params
    end
    
    it "assigns the section to @section" do
      get :edit, @params
      assigns[:section].should eql(@section)
    end
    
    it "assigns @section to @breadcrumb" do
      get :edit, @params
      assigns[:breadcrumb].should eql(@section)
    end
    
    it "renders the edit template" do
      get :edit, @params
      response.should render_template(:edit)
    end
    
  end
  
  describe "POST create" do
    
    before(:each) do
      @params = { :survey_id => @survey.id.to_s, :section => { "title" => "title" } }
      @sections.stub(:new).and_return(@section)
    end
    
    it "finds the survey into which a new section will be added" do
      @user.should_receive(:surveys).and_return(@surveys)
      @surveys.should_receive(:find).with(@params[:survey_id]).and_return(@survey)
      post :create, @params
    end
    
    it "assigns the survey to @survey" do
      post :create, @params
      assigns[:survey].should eql(@survey)
    end
    
    it "creates a new section within the survey using params[:section]" do
      @sections.should_receive(:new).with(@params[:section]).and_return(@section)
      post :create, @params
    end
    
    it "it assigns the section to @section" do
      post :create, @params
      assigns[:section].should eql(@section)
    end
    
    it "saves the section" do
      @section.should_receive(:save)
      post :create, @params
    end
    
    context "when the save is successful" do
      
      before(:each) do
        @section.stub(:save).and_return(true)
      end
      
      it "sets the flash message" do
        post :create, @params
        flash[:notice].should eql("Section created.")
      end
      
      it "redirects to section_path(@section)" do
        post :create, @params
        response.should redirect_to(section_path(@section))
      end
      
    end
    
    context "when the save is unsuccessful" do
      
      before(:each) do
        @section.stub(:save).and_return(false)
      end
      
      it "assigns @section to @breadcrumb" do
        post :create, @params
        assigns[:breadcrumb].should eql(@section)
      end
      
      it "renders the new template" do
        post :create, @params
        response.should render_template(:new)
      end
      
    end
    
  end
  
  describe "PUT update" do
    
    before(:each) do
      @params = { :id => @section.id.to_s, :section => { "title" => "title" } }
      @section.stub(:update_attributes)
    end
    
    it "finds the section" do
      @user.should_receive(:sections).and_return(@sections)
      @sections.should_receive(:find).with(@params[:id]).and_return(@section)
      put :update, @params
    end
    
    it "assigns the section to @section" do
      put :update, @params
      assigns[:section].should eql(@section)
    end
    
    it "updates the section with params[:section]" do
      @section.should_receive(:update_attributes).with(@params[:section])
      put :update, @params
    end
    
    context "when the update is successful" do
      
      before(:each) do
        @section.stub(:update_attributes).and_return(true)
      end
      
      it "sets the flash message" do
        put :update, @params
        flash[:notice].should eql("Section updated.")
      end
      
      it "redirects to section_path(@section)" do
        put :update, @params
        response.should redirect_to(section_path(@section))
      end
      
    end
    
    context "when the update is unsuccessful" do
      
      before(:each) do
        @section.stub(:update_attributes).and_return(false)
      end
      
      it "assigns @section to @breadcrumb" do
        put :update, @params
        assigns[:breadcrumb].should eql(@section)
      end
      
      it "renders the edit template" do
        put :update, @params
        response.should render_template(:edit)
      end
      
    end
    
  end
  
  describe "DELETE destroy" do
    
    before(:each) do
      @params = { :id => @section.id.to_s }
      @section.stub(:survey).and_return(@survey)
      @section.stub(:destroy)
    end
    
    it "finds the section" do
      @user.should_receive(:sections).and_return(@sections)
      @sections.should_receive(:find).with(@params[:id]).and_return(@section)
      delete :destroy, @params
    end
    
    it "assigns the section to @section" do
      delete :destroy, @params
      assigns[:section].should eql(@section)
    end
    
    it "finds the section's survey" do
      @section.should_receive(:survey).and_return(@survey)
      delete :destroy, @params
    end
    
    it "assigns the survey to @survey" do
      delete :destroy, @params
      assigns[:survey].should eql(@survey)
    end
    
    it "destroys the section" do
      @section.should_receive(:destroy)
      delete :destroy, @params
    end
    
    it "sets the flash message" do
      delete :destroy, @params
      flash[:notice].should eql("Section deleted.")
    end
    
    it "redirects to survey_path(@survey)" do
      delete :destroy, @params
      response.should redirect_to(survey_path(@survey))
    end
    
  end
  
  describe "GET confirm_delete" do
    
    before(:each) do
      @params = { :id => @section.id.to_s }
    end
    
    it "finds the section" do
      @user.should_receive(:sections).and_return(@sections)
      @sections.should_receive(:find).with(@params[:id]).and_return(@section)
      get :confirm_delete, @params
    end
    
    it "assigns the section to @section" do
      get :confirm_delete, @params
      assigns[:section].should eql(@section)
    end
    
    it "assigns @section to @breadcrumb" do
      get :confirm_delete, @params
      assigns[:breadcrumb].should eql(@section)
    end
    
    it "renders the confirm_delete template" do
      get :confirm_delete, @params
      response.should render_template(:confirm_delete)
    end
    
  end

end
