class ReportsController < ApplicationController
  
  before_filter :retrieve_user
  
  def index
    with_placeholder do
      @surveys = @user.surveys
      render :index
    end
  end
  
end