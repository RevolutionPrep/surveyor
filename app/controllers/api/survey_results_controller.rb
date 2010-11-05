class Api::SurveyResultsController < ApplicationController

  before_filter :retrieve_user

  def index
    respond_to do |format|
      case params[:version]
      when "1_0","1_1"
        if @survey = @user.surveys.find_by_api_key(params[:api_key]) rescue false
          @questions = @survey.sections.first.questions
          @question_results = []
          @questions.each do |question|
            @question_results << @user.question_results.find_all_by_question_id_and_survey_result_id(question.id, params[:results])
          end
          format.xml
        else
          format.xml { render :nothing => true, :status => 404 }
        end
      else
        format.xml { render :nothing => true, :status => 405 }
      end
    end
  end

  def show
    respond_to do |format|
      case params[:version]
      when "1_0","1_1"
        if @survey_result = @user.survey_results.find(params[:id]) rescue false
          format.xml
        else
          format.xml { render :nothing => true, :status => 404 }
        end
      else
        format.xml { render :nothing => true, :status => 405 }
      end
    end
  end

  def create
    respond_to do |format|
      case params[:version]
      when "1_0", "1_1"
        if @survey = @user.surveys.find_by_api_key(params[:survey_result]["key"]) rescue false
          @survey_result = @user.survey_results.build(:survey_id => @survey.id, :completed => true)
          begin
            @survey_result.build_results(params[:survey_result])
            @survey_result.save!
          rescue => ex
            format.xml { render :nothing => true, :status => 500 }
            HoptoadNotifier.notify(ex)
            logger.info ex.to_s
            logger.info ex.backtrace.join("\n")
          end
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