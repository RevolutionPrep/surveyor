require 'spec_helper'

describe QuestionsController do
  
  before(:each) do
    @question = mock_model(Question)
    @question.stub(:becomes).and_return(@question)
    @questions = [@question]
    @questions.stub(:find).and_return(@question)
    @questions.stub(:new).and_return(@question)
    @section = mock_model(Section, :questions => @questions)
    @sections = [@section]
    @sections.stub(:find).and_return(@section)
    @user = mock_model(User, :sections => @sections, :questions => @questions)
    controller.stub(:current_user).and_return(@user)
  end
  
  it "finds the current user" do
    controller.should_receive(:current_user).and_return(@user)
    get :index, :section_id => 1
  end
  
  context "when the section is not found" do
    
    before(:each) do
      @sections.stub(:find).and_raise(ActiveRecord::RecordNotFound)
    end
    
    it "sets the flash message" do
      get :index, :section_id => 1
      flash[:notice].should eql("You do not have access to this asset.")
    end
    
    it "redirects to root_url" do
      get :index, :section_id => 1
      response.should redirect_to(root_url)
    end
    
  end
  
  context "when the question is not found" do
    
    before(:each) do
      @questions.stub(:find).and_raise(ActiveRecord::RecordNotFound)
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

  describe "GET index" do
    
    before(:each) do
      @params = { :section_id => @section.id.to_s }
    end
    
    it "finds the section for this index of questions" do
      @user.should_receive(:sections).and_return(@sections)
      @sections.should_receive(:find).with(@params[:section_id]).and_return(@section)
      get :index, @params
    end
    
    it "assigns the section to @section" do
      get :index, @params
      assigns[:section].should eql(@section)
    end
    
    it "finds the questions belonging to this section" do
      @section.should_receive(:questions).and_return(@questions)
      get :index, @params
    end
    
    it "assigns the questions to @questions" do
      get :index, @params
      assigns[:questions].should eql(@questions)
    end
    
    it "renders the index template" do
      get :index, @params
      response.should render_template(:index)
    end
    
  end
  
  describe "GET show" do
    
    before(:each) do
      @params = { :id => @question.id.to_s }
    end
    
    it "finds the question" do
      @user.should_receive(:questions).and_return(@questions)
      @questions.should_receive(:find).with(@params[:id]).and_return(@question)
      get :show, @params
    end
    
    it "assigns the question to @question" do
      get :show, @params
      assigns[:question].should eql(@question)
    end
    
    it "renders the show template" do
      get :show, @params
      response.should render_template(:show)
    end
    
  end
  
  describe "GET new" do
    
    before(:each) do
      @params = { :section_id => @section.id.to_s }
    end
    
    it "finds the section to which a new question should be added" do
      @user.should_receive(:sections).and_return(@sections)
      @sections.should_receive(:find).with(@params[:section_id]).and_return(@section)
      get :new, @params
    end
    
    it "assigns the section to @section" do
      get :new, @params
      assigns[:section].should eql(@section)
    end
    
    it "creates a new question" do
      @questions.should_receive(:new)
      get :new, @params
    end
    
    it "assigns the question to @question" do
      get :new, @params
      assigns[:question].should eql(@question)
    end
    
    it "renders the new template" do
      get :new, @params
      response.should render_template(:new)
    end
    
  end
  
  describe "GET edit" do
    
    before(:each) do
      @params = { :id => @question.id.to_s }
    end
    
    it "finds the question" do
      @user.should_receive(:questions).and_return(@questions)
      @questions.should_receive(:find).with(@params[:id]).and_return(@question)
      get :edit, @params
    end
    
    it "assigns the question to @question" do
      get :edit, @params
      assigns[:question].should eql(@question)
    end
    
    it "sets session[:question_id] to the id of @question" do
      get :edit, @params
      session[:question_id].should eql(@question.id)
    end
    
    it "renders the edit template" do
      get :edit, @params
      response.should render_template(:edit)
    end
    
  end
  
  describe "POST create" do
    
    before(:each) do
      @params = { :section_id => @section.id.to_s, :question => { "statement" => "statement" } }
      @section.stub(:build_question).and_return(@question)
      @section.stub(:save)
    end
    
    it "finds the section to which the new question should be added" do
      @user.should_receive(:sections).and_return(@sections)
      @sections.should_receive(:find).with(@params[:section_id]).and_return(@section)
      post :create, @params
    end
    
    it "assigns the section to @section" do
      post :create, @params
      assigns[:section].should eql(@section)
    end
    
    it "calls build_question on @section with params[:question] which returns a typecast question" do
      @section.should_receive(:build_question).with(@params[:question]).and_return(@question)
      post :create, @params
    end
    
    it "assigns the question to @question" do
      post :create, @params
      assigns[:question].should eql(@question)
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
        flash[:notice].should eql("Question created.")
      end
      
      it "redirects to question_path(@question)" do
        post :create, @params
        response.should redirect_to(question_path(@question))
      end
      
    end
    
    context "when the save is unsuccessful" do
      
      before(:each) do
        @section.stub(:save).and_return(false)
      end
      
      it "renders the new template" do
        post :create, @params
        response.should render_template(:new)
      end
      
    end
    
  end
  
  describe "PUT update" do
    
    before(:each) do
      @params = { :id => @question.id.to_s, :question => { "statement" => "statement" } }
      @component = mock_model(Component)
      @components = [@component]
      @question.stub(:update_attributes)
      @question.stub(:components).and_return(@components)
    end
    
    it "finds the question" do
      @user.should_receive(:questions).and_return(@questions)
      @questions.should_receive(:find).with(@params[:id]).and_return(@question)
      put :update, @params
    end
    
    it "assigns the question to @question" do
      put :update, @params
      assigns[:question].should eql(@question)
    end
    
    it "checks to see if the question is of type 'MultipleChoiceQuestion'" do
      @question.should_receive(:class)
      put :update, @params
    end
    
    context "when the question is a MultipleChoiceQuestion" do
      
      before(:each) do
        @question.stub(:class).and_return(MultipleChoiceQuestion)
      end
      
      it "prefills the params[:question][:existing_components_attributes] if it is nil" do
        put :update, @params
        controller.params[:question][:existing_components_attributes].should eql({})
      end
      
    end
    
    context "when params[:question][:new_components_attributes] is not blank" do
      
      before(:each) do
        @params[:question].merge!(:new_components_attributes => [{ :value => "4" }])
      end
      
      it "prefills the user_id attribute for each component" do
        put :update, @params
        controller.params[:question][:new_components_attributes].each do |attributes|
          attributes[:user_id].should eql(@user.id)
        end
      end
      
    end
    
    context "when params[:commit] == 'Add'" do
      
      before(:each) do
        @params.merge!(:commit => "Add")
        @components.stub(:build).and_return(@component)
      end
      
      it "updates the question with params[:question]" do
        @question.should_receive(:update_attributes).with(@params[:question])
        put :update, @params
      end
      
      it "creates a new component for this question" do
        @question.should_receive(:components).and_return(@components)
        @components.should_receive(:build).and_return(:@component)
        put :update, @params
      end
      
      it "renders the edit template" do
        put :update, @params
        response.should render_template(:edit)
      end
      
    end
    
    context "when params[:commit] == 'Remove'" do
      
      before(:each) do
        @params.merge!(:commit => "Remove", :remove_component_ids => [@component.id.to_s])
        @components.stub(:find).and_return(@components)
        @component.stub(:destroy)
      end
      
      it "finds all components by ids from params[:remove_component_ids]" do
        @question.should_receive(:components).and_return(@components)
        @components.should_receive(:find).with(@params[:remove_component_ids]).and_return(@components)
        put :update, @params
      end
      
      it "destroys each of these components" do
        @component.should_receive(:destroy)
        put :update, @params
      end
      
      it "renders the edit template" do
        put :update, @params
        response.should render_template(:edit)
      end
      
    end
    
    context "when params[:commmit] is neither 'Add' nor 'Remove'" do
      
      it "updates the question with params[:question]" do
        @question.should_receive(:update_attributes).with(@params[:question])
        put :update, @params
      end
      
      context "when the update is successful" do
        
        before(:each) do
          @question.stub(:update_attributes).and_return(true)
        end
        
        it "sets the flash message" do
          put :update, @params
          flash[:notice].should eql("Question updated.")
        end
        
        it "redirects to questions_path(@question)" do
          put :update, @params
          response.should redirect_to(question_path(@question))
        end
        
      end
      
      context "when the update is unsuccessful" do
        
        before(:each) do
          @question.stub(:update_attributes).and_return(false)
        end
        
        it "renders the edit template" do
          put :update, @params
          response.should render_template(:edit)
        end
        
      end
      
    end
    
  end
  
  describe "DELETE destroy" do
    
    before(:each) do
      @params = { :id => @question.id.to_s }
      @question.stub(:section).and_return(@section)
      @question.stub(:destroy)
    end
    
    it "finds the question" do
      @user.should_receive(:questions).and_return(@questions)
      @questions.should_receive(:find).with(@params[:id]).and_return(@question)
      delete :destroy, @params
    end
    
    it "assigns the question to @question" do
      delete :destroy, @params
      assigns[:question].should eql(@question)
    end
    
    it "finds the section this question belongs to" do
      @question.should_receive(:section).and_return(@section)
      delete :destroy, @params
    end
    
    it "assigns the section to @section" do
      delete :destroy, @params
      assigns[:section].should eql(@section)
    end
    
    it "destroys the question" do
      @question.should_receive(:destroy)
      delete :destroy, @params
    end
    
    it "sets the flash message" do
      delete :destroy, @params
      flash[:notice].should eql("Question deleted.")
    end
    
    it "redirects to section_path(@section)" do
      delete :destroy, @params
      response.should redirect_to(section_path(@section))
    end
    
  end
  
  describe "GET confirm_delete" do
    
    before(:each) do
      @params = { :id => @question.id.to_s }
    end
    
    it "finds the question" do
      @user.should_receive(:questions).and_return(@questions)
      @questions.should_receive(:find).with(@params[:id]).and_return(@question)
      get :confirm_delete, @params
    end
    
    it "assigns the question to @question" do
      get :confirm_delete, @params
      assigns[:question].should eql(@question)
    end
    
    it "renders the confirm_delete template" do
      get :confirm_delete, @params
      response.should render_template(:confirm_delete)
    end
    
  end

end
