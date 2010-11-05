class SectionsController < ApplicationController

  before_filter :retrieve_user
  before_filter :retrieve_survey, :only => [:index, :new, :create]
  before_filter :retrieve_section, :except => [:index, :new, :create]

  def index
    @sections = @survey.sections
    @breadcrumb = @section || @survey
    respond_to do |format|
      format.html
    end
  end
  
  def show
    @breadcrumb = @section || @survey
    respond_to do |format|
      format.html
    end
  end
  
  def new
    @section = @survey.sections.new
    @breadcrumb = @section || @survey
    respond_to do |format|
      format.html
    end
  end
  
  def edit
    @breadcrumb = @section || @survey
    respond_to do |format|
      format.html
    end
  end

  def create
    @section = @survey.sections.new(params[:section])
    respond_to do |format|
      if @section.save
        flash[:notice] = "Section created."
        @breadcrumb = @section || @survey
        format.html { redirect_to section_path(@section) }
      else
        @breadcrumb = @section || @survey
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @section.update_attributes(params[:section])
        flash[:notice] = "Section updated."
        @breadcrumb = @section || @survey
        format.html { redirect_to section_path(@section) }
      else
        @breadcrumb = @section || @survey
        format.html { render :edit }
      end
    end
  end

  def destroy
    @survey = @section.survey
    @section.destroy
    @breadcrumb = @section || @survey
    respond_to do |format|
      flash[:notice] = "Section deleted."
      format.html { redirect_to survey_path(@survey) }
    end
  end

  def confirm_delete
    @breadcrumb = @section || @survey
    respond_to do |format|
      format.html
    end
  end

  private

    def retrieve_survey
      @survey = @user.surveys.find(params[:survey_id])
    end
    
    def retrieve_section
      @section = @user.sections.find(params[:id])
    end

end