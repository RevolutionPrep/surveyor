class ReportsController < ApplicationController
  
  before_filter :retrieve_user
  
  def index
    with_placeholder do
      @surveys = @user.surveys
      render :index
    end
  end
  
  def show
    with_placeholder do
      @survey = @user.surveys.find(params[:id])
      render :show
    end
  end
  
end