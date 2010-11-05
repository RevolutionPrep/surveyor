require 'spec_helper'

describe UsersController do
  
  before(:each) do
    controller.stub(:retrieve_user).and_return(true)
  end

  describe "GET new" do
    
    before(:each) do
      @user = mock_model(User)
      User.stub(:new).and_return(@user)
    end
    
    it "creates a new user" do
      User.should_receive(:new)
      get :new
    end
    
    it "assigns the new user to @user" do
      get :new
      assigns[:user].should eql(@user)
    end
    
    it "renders the new template" do
      get :new
      response.should render_template(:new)
    end
    
  end
  
  describe "GET edit" do
    
    before(:each) do
      @user = mock_model(User)
      controller.stub(:current_user).and_return(@user)
    end
    
    it "finds the current user" do
      controller.should_receive(:current_user)
      get :edit, :id => :current
    end
    
    it "assigns the current user to @user" do
      get :edit, :id => :current
      assigns[:user].should eql(@user)
    end
    
    it "renders the edit template" do
      get :edit, :id => :current
      response.should render_template(:edit)
    end
    
  end
  
  describe "POST create" do
    
    before(:each) do
      @user = mock_model(User)
      @user.stub(:save)
      User.stub(:new).and_return(@user)
      @params = { :user => { "username" => "username" } }
    end
    
    it "creates a new user with the parameters from the request" do
      User.should_receive(:new).with(@params[:user]).and_return(@user)
      post :create, @params
    end
    
    it "assigns the new user to @user" do
      post :create, @params
      assigns[:user].should eql(@user)
    end
    
    it "saves the user" do
      @user.should_receive(:save)
      post :create, @params
    end
    
    context "when the new user is saved with valid attributes" do
      
      before(:each) do
        @user.stub(:save).and_return(true)
        @user.stub(:username).and_return("username")
      end
      
      it "sets the flash message" do
        post :create, @params
        flash[:notice].should eql("Registration successful! Welcome, username.")
      end
      
      it "redirects to the surveys index" do
        post :create, @params
        response.should redirect_to(surveys_path)
      end
      
    end
    
    context "when the new user is saved with invalid attributes" do
      
      before(:each) do
        @user.stub(:save).and_return(false)
      end
      
      it "renders the new template" do
        post :create, @params
        response.should render_template(:new)
      end
      
    end
  
  end
  
  describe "PUT update" do
    
    before(:each) do
      @user = mock_model(User)
      @user.stub(:update_attributes)
      @params = { :id => @user.id.to_s, :user => { "username" => "username" } }
      User.stub(:find).with(@params[:id]).and_return(@user)
    end
    
    it "finds the user with the given :id parameter" do
      User.should_receive(:find).with(@params[:id]).and_return(@user)
      put :update, @params
    end
    
    it "assigns the found user to @user" do
      put :update, @params
      assigns[:user].should eql(@user)
    end
    
    it "updates the user record" do
      @user.should_receive(:update_attributes).with(@params[:user])
      put :update, @params
    end
    
    context "when the user is updated with valid attributes" do
      
      before(:each) do
        @user.stub(:update_attributes).and_return(true)
      end
      
      it "sets the flash message" do
        put :update, @params
        flash[:notice].should eql("Profile successfully updated.")
      end
      
      it "redirects to the surveys index" do
        put :update, @params
        response.should redirect_to(surveys_path)
      end
      
    end
    
    context "when the user is updated with invalid attributes" do
      
      before(:each) do
        @user.stub(:update_attributes).and_return(false)
      end
      
      it "renders the edit template" do
        put :update, @params
        response.should render_template(:edit)
      end
      
    end
    
  end

end