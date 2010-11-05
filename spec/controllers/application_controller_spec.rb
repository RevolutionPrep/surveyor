require 'spec_helper'

describe ApplicationController do
  
  before(:each) do
    @user_session = mock_model(UserSession)
    UserSession.stub(:find).and_return(@user_session)
    @user = mock_model(User)
    @user_session.stub(:record).and_return(@user)
  end
  
  describe ".current_user_session" do
    
    it "returns a UserSession" do
      controller.send(:current_user_session).should eql(@user_session)
    end
  end
  
  describe ".current_user" do
    
    it "returns a user model" do
      controller.send(:current_user).should eql(@user)
    end
    
  end
  
  describe ".retrieve_user" do
    # TODO: specs
  end
  
  describe ".access_denied" do
    # TODO: specs
  end

end