class ResultsController < ApplicationController
  
  before_filter :retrieve_user
  
  def index
    with_placeholder "reports/placeholder" do
      @survey = @user.surveys.find(params[:report_id])
      @survey_results = @survey.survey_results
      render :index
    end
  end
  
end