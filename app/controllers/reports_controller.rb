class ReportsController < ApplicationController
  
  before_filter :retrieve_user
  
  def index
    @surveys = @user.surveys
  end
  
end