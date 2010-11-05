class Api::QuestionResultsController < ApplicationController

  before_filter :retrieve_user

  def show
    respond_to do |format|
      if request.post?
        case params[:version]
        when "1_1"
          if @survey = @user.surveys.find_by_api_key(params[:hash][:api_key]) rescue false
            @questions = @survey.sections.first.questions.find_all_by_handle(params[:hash][:handles].split(","))
            @question_results, @question_counts, @short_answer_results = QuestionResultReporter.build(@questions, params[:hash][:results])
            format.xml
          else
            format.xml { render :nothing => true, :status => 404 }
          end
        else
          format.xml { render :nothing => true, :status => 405 }
        end
      else
        case params[:version]
        when "1_1"
          if @survey = @user.surveys.find_by_api_key(params[:api_key]) rescue false
            @questions = @survey.sections.first.questions.find_all_by_handle(params[:handles])
            @questions.each do |question|
              (@question_results ||= []) << @user.question_results.find_all_by_question_id_and_survey_result_id(question.id, params[:results])
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

  def headcount
    respond_to do |format|
      case params[:version]
      when "1_1"
        if @survey = @user.surveys.find_by_api_key(params[:api_key]) rescue false
          if @question = @survey.sections.first.questions.find_by_handle(params[:handle]) rescue false
            case @question
            when MultipleChoiceQuestion
              if @component = @question.components.find_by_value(params[:choice]) rescue false
                @question_results = @user.question_results.find_all_by_question_id_and_component_id_and_survey_result_id(@question.id, @component.id, params[:results])
              else
                format.xml { render :nothing => true, :status => 404 }
              end
            when RatingQuestion
              if @rating_label = @question.rating_scale.rating_labels.find_by_key(params[:choice]) rescue false
                @question_results = @user.question_results.find_all_by_question_id_and_rating_label_id_and_survey_result_id(@question.id, @rating_label.id, params[:results]) rescue nil
              else
                format.xml { render :nothing => true, :status => 404 }
              end
            end
            @total_results = @user.question_results.find_all_by_question_id_and_survey_result_id(@question.id, params[:results])
            format.xml
          else
            format.xml { render :nothing => true, :status => 404 }
          end
        else
          format.xml { render :nothing => true, :status => 404 }
        end
      else
        format.xml { render :nothing => true, :status => 405 }
      end
    end
  end

  def gpa
    respond_to do |format|
      case params[:version]
      when "1_1"
        if @survey = @user.surveys.find_by_api_key(params[:api_key]) rescue false
          if @question = @survey.sections.first.questions.find_by_handle(params[:handle]) rescue false
            @question_results = @user.question_results.find_all_by_question_id_and_survey_result_id(@question.id, params[:results])
            format.xml
          else
            format.xml { render :nothing => true, :status => 404 }
          end
        else
          format.xml { render :nothing => true, :status => 404 }
        end
      else
        format.xml { render :nothing => true, :status => 405 }
      end
    end
  end

end