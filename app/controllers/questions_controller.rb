class QuestionsController < ApplicationController

  before_filter :retrieve_user
  before_filter :retrieve_section, :only => [:index, :new, :create]
  before_filter :retrieve_question, :except => [:index, :new, :create]

  def index
    @questions = @section.questions
    @breadcrumb = @question.try(:becomes, Question) || @section
    respond_to do |format|
      format.html
    end
  end
  
  def show
    @breadcrumb = @question.try(:becomes, Question) || @section
    respond_to do |format|
      format.html
    end
  end

  def new
    @question = @section.questions.new
    @breadcrumb = @question.try(:becomes, Question) || @section
    respond_to do |format|
      format.html
    end
  end
  
  def edit
    session[:question_id] = @question.id
    @breadcrumb = @question.try(:becomes, Question) || @section
    respond_to do |format|
      format.html
    end
  end
  
  def create
    @question = @section.build_question(params[:question])
    respond_to do |format|
      if @section.save
        flash[:notice] = "Question created."
        @breadcrumb = @question.try(:becomes, Question) || @section
        format.html { redirect_to question_path(@question) }
      else
        @breadcrumb = @question.try(:becomes, Question) || @section
        format.html { render :new }
      end
    end
  end

  def update
    if @question.class == MultipleChoiceQuestion
      params[:question][:existing_components_attributes] ||= {}
    end
    unless params[:question][:new_components_attributes].blank?
      params[:question][:new_components_attributes].each_with_index do |attributes, index|
        params[:question][:new_components_attributes][index].merge!(:user_id => current_user.id)
      end
    end
    respond_to do |format|
      case params[:commit]
      when "Add"
        @question.update_attributes(params[:question])
        @question.components.build
        @breadcrumb = @question.try(:becomes, Question) || @section
        format.html { render :edit }
      when "Remove"
        components = @question.components.find(params[:remove_component_ids])
        components.each do |component|
          component.destroy
        end
        @breadcrumb = @question.try(:becomes, Question) || @section
        format.html { render :edit }
      else
        if @question.update_attributes(params[:question])
          flash[:notice] = "Question updated."
          @breadcrumb = @question.try(:becomes, Question) || @section
          format.html { redirect_to question_path(@question) }
        else
          @breadcrumb = @question.try(:becomes, Question) || @section
          format.html { render :edit }
        end
      end
    end
  end

  def destroy
    @section = @question.section
    @question.destroy
    @breadcrumb = @question.try(:becomes, Question) || @section
    respond_to do |format|
      flash[:notice] = "Question deleted."
      format.html { redirect_to section_path(@section) }
    end
  end

  def confirm_delete
    @breadcrumb = @question.try(:becomes, Question) || @section
    respond_to do |format|
      format.html
    end
  end

  private

    def retrieve_section
      @section = @user.sections.find(params[:section_id])
    end
    
    def retrieve_question
      @question = @user.questions.find(params[:id])
    end

end