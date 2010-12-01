class SectionsController < ApplicationController

  before_filter :retrieve_user
  before_filter :retrieve_survey, :only => [:index, :new, :create]
  before_filter :retrieve_section, :except => [:index, :new, :create]
  before_render :set_breadcrumb

  def index
    @sections = @survey.sections
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
    @section = @survey.sections.new
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
    @section = @survey.sections.new(params[:section])
    respond_to do |format|
      if @section.save
        flash[:notice] = "Section created."
        format.html { redirect_to section_path(@section) }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @section.update_attributes(params[:section])
        flash[:notice] = "Section updated."
        format.html { redirect_to section_path(@section) }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @survey = @section.survey
    @section.destroy
    respond_to do |format|
      flash[:notice] = "Section deleted."
      format.html { redirect_to survey_path(@survey) }
    end
  end

  def confirm_delete
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
    
    def set_breadcrumb
      @breadcrumb = @section || @survey
    end

end