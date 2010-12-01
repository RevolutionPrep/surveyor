class SurveysController < ApplicationController

  before_filter :retrieve_user
  before_filter :retrieve_survey, :except => [:index, :new, :create]
  before_render :set_breadcrumb

  def index
    @surveys = @user.surveys
    respond_to do |format|
      format.html
    end
  end
  
  def show
    respond_to do |format|
      format.html
    end
  end

  def new
    @survey = @user.surveys.new
    respond_to do |format|
      format.html
    end
  end
  
  def edit
    respond_to do |format|
      format.html
    end
  end
  
  def create
    @survey = @user.surveys.build(params[:survey])
    respond_to do |format|
      if @survey.save
        flash[:notice] = "#{@survey.title} created."
        format.html { redirect_to survey_path(@survey) }
      else
        format.html { render :new }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @survey.update_attributes(params[:survey])
        flash[:notice] = "#{@survey.title} updated."
        format.html { redirect_to survey_path(@survey) }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @survey.destroy
    respond_to do |format|
      flash[:notice] = "Survey deleted."
      format.html { redirect_to surveys_path }
    end
  end

  def confirm_delete
    respond_to do |format|
      format.html
    end
  end
  
  private
  
    def retrieve_survey
      @survey = @user.surveys.find(params[:id])
    end
    
    def set_breadcrumb
      @breadcrumb = @survey
    end

end