class Api::SurveysController < ApplicationController

  before_filter :retrieve_user

  def show
    respond_to do |format|
      case params[:version]
      when "1_0", "1_1"
        if @survey = @user.surveys.find_by_api_key(params[:id]) rescue false
          format.xml
        else
          format.xml { render :nothing => true, :status => 404 }
        end
      else
        format.xml { render :nothing => true, :status => 405 }
      end
    end
  end

end