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
      @survey_results = @survey.survey_results
      render :show
    end
  end
  
end