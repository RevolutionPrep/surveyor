require 'spec_helper'

describe UserSessionsController do

  describe "GET new" do
    
    before(:each) do
      @user_session = mock_model(UserSession)
      UserSession.stub(:new).and_return(@user_session)
    end
    
    it "creates a new UserSession" do
      UserSession.should_receive(:new).and_return(@user_session)
      get :new
    end
    
    it "assigns the new UserSession to @user_session" do
      get :new
      assigns[:user_session].should eql(@user_session)
    end
    
    it "renders the new template" do
      get :new
      response.should render_template(:new)
    end
    
  end
  
  describe "POST create" do
    
    before(:each) do
      @params = { :user_session => { "username" => "username", "password" => "password" } }
      @user_session = mock_model(UserSession, :username => @params[:user_session]["username"])
      @user_session.stub(:save)
      UserSession.stub(:new).and_return(@user_session)
    end
    
    it "creates a new UserSession with params[:user_session]" do
      UserSession.should_receive(:new).with(@params[:user_session])
      post :create, @params
    end
    
    it "assigns the new UserSession to @user_session" do
      post :create, @params
      assigns[:user_session].should eql(@user_session)
    end
    
    it "it saves the UserSession" do
      @user_session.should_receive(:save)
      post :create, @params
    end
    
    context "when the UserSession is created with valid attributes" do
      
      before(:each) do
        @user_session.stub(:save).and_return(true)
      end
      
      it "sets the flash message" do
        post :create, @params
        flash[:notice].should eql("Welcome, #{@user_session.username}!")
      end
      
      it "redirects to the root url" do
        post :create, @params
        response.should redirect_to(root_url)
      end
      
    end
    
    context "when the UserSession is created with invalid attributes" do
      
      before(:each) do
        @user_session.stub(:save).and_return(false)
      end
      
      it "renders the new template" do
        post :create, @params
        response.should render_template(:new)
      end
      
    end
    
  end
  
  describe "DELETE destroy" do
    
    before(:each) do
      @user_session = mock_model(UserSession)
      @user_session.stub(:destroy)
      UserSession.stub(:find).and_return(@user_session)
    end
    
    it "finds the UserSession" do
      UserSession.should_receive(:find).and_return(@user_session)
      delete :destroy
    end
    
    it "assigns the UserSession to @user_session" do
      delete :destroy
      assigns[:user_session].should eql(@user_session)
    end
    
    it "destroys the UserSession" do
      @user_session.should_receive(:destroy)
      delete :destroy
    end
    
    it "sets the flash message" do
      delete :destroy
      flash[:notice].should eql("Goodbye.")
    end
    
    it "redirects to the login path" do
      delete :destroy
      response.should redirect_to(login_path)
    end
    
  end

end
