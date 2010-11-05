require 'spec_helper'

module ComponentSpecHelpers
  
  def valid_component_attributes
    {
      :value    => "value for value",
      :question => mock_model(Question),
      :user     => mock_model(User)
    }
  end
  
end

describe Component, "validations" do
  include ComponentSpecHelpers
  
  before(:each) do
    @component = Component.new
  end

  it "is valid given valid attributes" do
    @component.attributes = valid_component_attributes
    @component.should be_valid
  end
  
  it "has an error on value when value is blank" do
    @component.attributes = valid_component_attributes.except(:value)
    @component.should_not be_valid
    @component.should have(1).error_on(:value)
  end
  
  it "has an error on question_id when question_id is blank" do
    @component.attributes = valid_component_attributes.except(:question)
    @component.should_not be_valid
    @component.should have(1).error_on(:question_id)
  end
  
  it "has an error on user_id when user_id is blank" do
    @component.attributes = valid_component_attributes.except(:user)
    @component.should_not be_valid
    @component.should have(1).error_on(:user_id)
  end
  
end

describe Component, "acts_as_list" do
  
  before(:each) do
    @user = mock_model(User)
  end
  
  it "prescribes the correct order to components belonging to the same question" do
    @question = mock_model(Question)
    @component_1 = Component.create!(:value => "A", :question => @question, :user => @user)
    @component_2 = Component.create!(:value => "B", :question => @question, :user => @user)
    @component_1.position.should eql(1)
    @component_2.position.should eql(2)
  end
  
  it "prescribes different orders to components belonging to different questions" do
    @question_1 = mock_model(Question)
    @question_2 = mock_model(Question)
    @component_1 = Component.create!(:value => "A", :question => @question_1, :user => @user)
    @component_2 = Component.create!(:value => "B", :question => @question_2, :user => @user)
    @component_1.position.should eql(1)
    @component_2.position.should eql(1)
  end
  
end