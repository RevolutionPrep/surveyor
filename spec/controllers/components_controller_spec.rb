require 'spec_helper'

describe ComponentsController do
  
  before(:each) do
    @question = mock_model(Question)
    @component = mock_model(Component, :question => @question)
    @components = [@component]
    @components.stub(:find).and_return(@component)
    @user = mock_model(User, :components => @components)
    controller.stub(:current_user).and_return(@user)
  end

  it "finds the current user" do
    controller.should_receive(:current_user)
    get :confirm_delete, :id => 1
  end
  
  context "when the component is not found" do
    
    before(:each) do
      @components.stub(:find).and_raise(ActiveRecord::RecordNotFound)
    end
    
    it "sets the flash message" do
      get :confirm_delete, :id => 1
      flash[:notice].should eql("You do not have access to this asset.")
    end
    
    it "redirects to root_url" do
      get :confirm_delete, :id => 1
      response.should redirect_to(root_url)
    end
    
  end
  
  describe "DELETE destroy" do
    
    before(:each) do
      @params = { :id => @component.id.to_s }
      @component.stub(:destroy)
    end
    
    it "finds the component" do
      @user.should_receive(:components).and_return(@components)
      @components.should_receive(:find).with(@params[:id]).and_return(@component)
      delete :destroy, @params
    end
    
    it "assigns the component to @component" do
      delete :destroy, @params
      assigns[:component].should eql(@component)
    end
    
    it "finds the component's question" do
      @component.should_receive(:question).and_return(@question)
      delete :destroy, @params
    end
    
    it "assigns the question to @question" do
      delete :destroy, @params
      assigns[:question].should eql(@question)
    end
    
    it "destroys the component" do
      @component.should_receive(:destroy)
      delete :destroy, @params
    end
    
    it "redirects to edit_question_path(@question)" do
      delete :destroy, @params
      response.should redirect_to(edit_question_path(@question))
    end
    
  end
  
  describe "GET confirm_delete" do
    
    before(:each) do
      @params = { :id => @component.id.to_s }
    end
    
    it "finds the component" do
      @user.should_receive(:components).and_return(@components)
      @components.should_receive(:find).with(@params[:id]).and_return(@component)
      get :confirm_delete, @params
    end
    
    it "assigns the component to @component" do
      get :confirm_delete, @params
      assigns[:component].should eql(@component)
    end
    
    it "renders the confirm_delete template" do
      get :confirm_delete, @params
      response.should render_template(:confirm_delete)
    end
    
  end

end
