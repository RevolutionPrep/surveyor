class SurveysController < ApplicationController

  before_filter :retrieve_user
  before_filter :retrieve_survey, :except => [:index, :new, :create]

  def index
    @surveys = @user.surveys
    @breadcrumb = @survey
    respond_to do |format|
      format.html
    end
  end
  
  def show
    @breadcrumb = @survey
    respond_to do |format|
      format.html
    end
  end

  def new
    @survey = @user.surveys.new
    @breadcrumb = @survey
    respond_to do |format|
      format.html
    end
  end
  
  def edit
    @breadcrumb = @survey
    respond_to do |format|
      format.html
    end
  end
  
  def create
    @survey = @user.surveys.build(params[:survey])
    respond_to do |format|
      if @survey.save
        flash[:notice] = "#{@survey.title} created."
        @breadcrumb = @survey
        format.html { redirect_to survey_path(@survey) }
      else
        @breadcrumb = @survey
        format.html { render :new }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @survey.update_attributes(params[:survey])
        flash[:notice] = "#{@survey.title} updated."
        @breadcrumb = @survey
        format.html { redirect_to survey_path(@survey) }
      else
        @breadcrumb = @survey
        format.html { render :edit }
      end
    end
  end

  def destroy
    @survey.destroy
    @breadcrumb = @survey
    respond_to do |format|
      flash[:notice] = "Survey deleted."
      format.html { redirect_to surveys_path }
    end
  end

  def confirm_delete
    @breadcrumb = @survey
    respond_to do |format|
      format.html
    end
  end
  
  private
  
    def retrieve_survey
      @survey = @user.surveys.find(params[:id])
    end

end