require 'spec_helper'

describe RatingLabelsController do
  
  before(:each) do
    @rating_label = mock_model(RatingLabel)
    @rating_labels = [@rating_label]
    @rating_labels.stub(:find).and_return(@rating_label)
    @user = mock_model(User, :rating_labels => @rating_labels)
    controller.stub(:current_user).and_return(@user)
  end

  it "finds the current user" do
    controller.should_receive(:current_user).and_return(@user)
    get :confirm_delete, :id => 1
  end
  
  context "when the rating label is not found" do
    
    before(:each) do
      @rating_labels.stub(:find).and_raise(ActiveRecord::RecordNotFound)
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
      @params = { :id => @rating_label.id.to_s }
      @rating_label.stub(:destroy)
      @rating_scale = mock_model(RatingScale)
      @rating_label.stub(:rating_scale).and_return(@rating_scale)
    end
    
    it "finds the rating label" do
      @user.should_receive(:rating_labels).and_return(@rating_labels)
      @rating_labels.should_receive(:find).with(@params[:id]).and_return(@rating_label)
      delete :destroy, @params
    end
    
    it "assigns the rating label to @rating_label" do
      delete :destroy, @params
      assigns[:rating_label].should eql(@rating_label)
    end
    
    it "finds the rating scale this rating label belongs to" do
      @rating_label.should_receive(:rating_scale).and_return(@rating_scale)
      delete :destroy, @params
    end
    
    it "assigns the rating scale to @rating_scale" do
      delete :destroy, @params
      assigns[:rating_scale].should eql(@rating_scale)
    end
    
    it "destroys the rating label" do
      @rating_label.should_receive(:destroy)
      delete :destroy, @params
    end
    
    it "sets the flash message" do
      delete :destroy, @params
      flash[:notice].should eql("Rating label deleted.")
    end
    
    it "redirects to edit_rating_scale_path(@rating_scale)" do
      delete :destroy, @params
      response.should redirect_to(edit_rating_scale_path(@rating_scale))
    end
    
  end
  
  describe "GET confirm_delete" do
    
    before(:each) do
      @params = { :id => @rating_label.id.to_s }
    end
    
    it "finds the rating label" do
      @user.should_receive(:rating_labels).and_return(@rating_labels)
      @rating_labels.should_receive(:find).with(@params[:id]).and_return(@rating_label)
      get :confirm_delete, @params
    end
    
    it "assigns the rating label to @rating_label" do
      get :confirm_delete, @params
      assigns[:rating_label].should eql(@rating_label)
    end
    
    it "renders the confirm_delete template" do
      get :confirm_delete, @params
      response.should render_template(:confirm_delete)
    end
    
  end

end
