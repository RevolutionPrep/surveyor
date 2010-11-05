require 'spec_helper'

describe RatingScalesController do
  
  before(:each) do
    @rating_scale = mock_model(RatingScale)
    @rating_scales = [@rating_scale]
    @rating_scales.stub(:find).and_return(@rating_scale)
    @rating_scales.stub(:new).and_return(@rating_scale)
    @question = mock_model(Question)
    @questions = [@question]
    @user = mock_model(User, :rating_scales => @rating_scales, :questions => @questions)
    controller.stub(:current_user).and_return(@user)
  end
  
  it "finds the current user" do
    controller.should_receive(:current_user).and_return(@user)
    get :index
  end
  
  context "when the rating scale is not found" do
    
    before(:each) do
      @rating_scales.stub(:find).and_raise(ActiveRecord::RecordNotFound)
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
    
    context "when session[:question_id] is valid" do
      
      before(:each) do
        @questions.stub(:find).and_return(@question)
      end
    
      it "finds the question to which the user can return" do
        @user.should_receive(:questions).and_return(@questions)
        @questions.should_receive(:find).with(@question.id.to_s)
        get :index, {}, :question_id => @question.id.to_s
      end
      
      it "assigns the found question to @question" do
        get :index, {}, :question_id => @question.id.to_s
        assigns[:question].should eql(@question)
      end
      
    end
    
    context "when session[:question_id] is invalid" do
      
      before(:each) do
        @questions.stub(:find).and_raise(ActiveRecord::RecordNotFound)
      end
      
      it "finds nothing and returns a nil value" do
        @user.should_receive(:questions).and_return(@questions)
        @questions.should_receive(:find).with(nil).and_raise(ActiveRecord::RecordNotFound)
        get :index
      end
    
      it "assigns nil to @question" do
        get :index
        assigns[:question].should be_nil
      end
      
    end
    
    it "finds the rating scales belonging to this user" do
      @user.should_receive(:rating_scales).and_return(@rating_scales)
      get :index
    end
    
    it "renders the index template" do
      get :index
      response.should render_template(:index)
    end
    
  end
  
  describe "GET show" do
    
    before(:each) do
      @params = { :id => @rating_scale.id.to_s }
    end
    
    it "finds the rating scale" do
      @user.should_receive(:rating_scales).and_return(@rating_scales)
      @rating_scales.should_receive(:find).with(@params[:id]).and_return(@rating_scale)
      get :show, @params
    end
    
    it "assigns the rating scale to @rating_scale" do
      get :show, @params
      assigns[:rating_scale].should eql(@rating_scale)
    end
    
    it "renders the new template" do
      get :show, @params
      response.should render_template(:show)
    end
    
  end
  
  describe "GET new" do
    
    it "creates a new rating scale" do
      @user.should_receive(:rating_scales).and_return(@rating_scales)
      @rating_scales.should_receive(:new).and_return(@rating_scale)
      get :new
    end
    
    it "assigns the new rating scale to @rating_scale" do
      get :new
      assigns[:rating_scale].should eql(@rating_scale)
    end
    
    it "renders the new template" do
      get :new
      response.should render_template(:new)
    end
    
  end
  
  describe "GET edit" do
    
    before(:each) do
      @params = { :id => @rating_scale.id.to_s }
    end
    
    it "finds the rating scale" do
      @user.should_receive(:rating_scales).and_return(@rating_scales)
      @rating_scales.should_receive(:find).with(@params[:id]).and_return(@rating_scale)
      get :edit, @params
    end
    
    it "assigns the rating scale to @rating_scale" do
      get :edit, @params
      assigns[:rating_scale].should eql(@rating_scale)
    end
    
    it "renders the edit template" do
      get :edit, @params
      response.should render_template(:edit)
    end
    
  end
  
  describe "POST create" do
    
    before(:each) do
      @params = { :rating_scale => { "name" => "name" } }
      @rating_scale.stub(:save)
    end
    
    it "creates a new rating scale with params[:rating_scale]" do
      @user.should_receive(:rating_scales).and_return(@rating_scales)
      @rating_scales.should_receive(:new).with(@params[:rating_scale]).and_return(@rating_scale)
      post :create, @params
    end
    
    it "assigns the new rating scale to @rating_scale" do
      post :create, @params
      assigns[:rating_scale].should eql(@rating_scale)
    end
    
    it "saves the new rating scale" do
      @rating_scale.should_receive(:save)
      post :create, @params
    end
    
    context "when the save is successful" do
      
      before(:each) do
        @rating_scale.stub(:save).and_return(true)
      end
      
      it "sets the flash message" do
        post :create, @params
        flash[:notice].should eql("Rating scale created.")
      end
      
      it "redirects to edit_rating_scale_path(@rating_scale)" do
        post :create, @params
        response.should redirect_to(edit_rating_scale_path(@rating_scale))
      end
      
    end
    
    context "when the save is unsuccessful" do
      
      before(:each) do
        @rating_scale.stub(:save).and_return(false)
      end
      
      it "renders the new template" do
        post :create, @params
        response.should render_template(:new)
      end
      
    end
    
  end
  
  describe "PUT update" do
    
    before(:each) do
      @params = { :id => @rating_scale.id.to_s, :rating_scale => { "name" => "name" } }
      @rating_scale.stub(:update_attributes)
    end
    
    it "finds the rating scale" do
      @user.should_receive(:rating_scales).and_return(@rating_scales)
      @rating_scales.should_receive(:find).with(@params[:id]).and_return(@rating_scale)
      put :update, @params
    end
    
    it "assigns the found rating scale to @rating_scale" do
      put :update, @params
      assigns[:rating_scale].should eql(@rating_scale)
    end
    
    it "updates the rating scale with params[:rating_scale]" do
      @rating_scale.should_receive(:update_attributes).with(@params[:rating_scale])
      put :update, @params
    end
    
    context "when the update is successful" do
      
      before(:each) do
        @rating_scale.stub(:update_attributes).and_return(true)
      end
      
      context "when params[:commit] == 'Add Label'" do
        
        before(:each) do
          @params.merge!(:commit => "Add Label")
          @rating_label = mock_model(RatingLabel)
          @rating_labels = [@rating_label]
          @rating_scale.stub_chain(:rating_labels, :new)
        end
        
        it "builds a new rating label for this rating scale" do
          @rating_scale.should_receive(:rating_labels).and_return(@rating_labels)
          @rating_labels.should_receive(:new)
          put :update, @params
        end
        
        it "renders the edit template" do
          put :update, @params
          response.should render_template(:edit)
        end
        
      end
      
      context "when params[:commit] != 'Add Label'" do
        
        before(:each) do
          @params.merge!(:commit => "Update")
        end
        
        it "sets the flash message" do
          put :update, @params
          flash[:notice].should eql("Rating scale updated.")
        end
        
        it "redirects_to rating_scale_path(@rating_scale)" do
          put :update, @params
          response.should redirect_to(rating_scale_path(@rating_scale))
        end
        
      end
      
    end
    
    context "when the update is unsuccessful" do
      
      before(:each) do
        @rating_scale.stub(:update_attributes).and_return(false)
      end
      
      it "renders the edit template" do
        put :update, @params
        response.should render_template(:edit)
      end
      
    end
    
  end
  
  describe "DELETE destroy" do
    
    before(:each) do
      @params = { :id => @rating_scale.id.to_s }
      @rating_scale.stub(:destroy)
    end
    
    it "finds the rating scale" do
      @user.should_receive(:rating_scales).and_return(@rating_scales)
      @rating_scales.should_receive(:find).with(@params[:id]).and_return(@rating_scale)
      delete :destroy, @params
    end
    
    it "assigns the rating scale to @rating_scale" do
      delete :destroy, @params
      assigns[:rating_scale].should eql(@rating_scale)
    end
    
    it "destroys the rating scale" do
      @rating_scale.should_receive(:destroy)
      delete :destroy, @params
    end
    
    it "sets the flash message" do
      delete :destroy, @params
      flash[:notice].should eql("Rating scale deleted.")
    end
    
    it "redirects to rating_scales_path" do
      delete :destroy, @params
      response.should redirect_to(rating_scales_path)
    end
    
  end
  
  describe "GET confirm_delete" do
    
    before(:each) do
      @params = { :id => @rating_scale.id.to_s }
      @survey = mock_model(Survey)
      @surveys = [@survey]
      @questions.stub(:find_all_by_rating_scale_id).and_return(@questions)
      @question.stub_chain(:section, :survey).and_return(@survey)
    end
    
    it "finds the rating scale" do
      @user.should_receive(:rating_scales).and_return(@rating_scales)
      @rating_scales.should_receive(:find).with(@params[:id]).and_return(@rating_scale)
      get :confirm_delete, @params
    end
    
    it "assigns the rating scale to @rating_scale" do
      get :confirm_delete, @params
      assigns[:rating_scale].should eql(@rating_scale)
    end
    
    it "finds all questions using this rating scale" do
      @questions.should_receive(:find_all_by_rating_scale_id).with(@params[:id]).and_return(@questions)
      get :confirm_delete, @params
    end
    
    it "assigns these questions to @questions" do
      get :confirm_delete, @params
      assigns[:questions].should eql(@questions)
    end
    
    it "collects all unique surveys covered by these questions" do
      @questions.should_receive(:collect).and_return(@questions)
      @questions.should_receive(:uniq).and_return(@surveys)
      get :confirm_delete, @params
    end
    
    it "assigns the surveys to @surveys" do
      get :confirm_delete, @params
      assigns[:surveys].should eql(@surveys)
    end
    
    it "renders the confirm_delete template" do
      get :confirm_delete, @params
      response.should render_template(:confirm_delete)
    end
    
  end

end
