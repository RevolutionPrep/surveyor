require 'spec_helper'

module UserSpecHelpers
  
  def valid_user_attributes
    {
      :username => "username",
      :password => "password",
      :password_confirmation => "password"
    }
  end
  
end

describe User do
  include UserSpecHelpers
  
  before(:each) do
    @user = User.new
  end

  it "is valid given valid attributes" do
    @user.attributes = valid_user_attributes
    @user.should be_valid
  end

end