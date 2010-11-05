class ComponentsController < ApplicationController

  before_filter :retrieve_user
  before_filter :retrieve_component

  def destroy
    @question = @component.question
    @component.destroy
    flash[:notice] = "Answer choice successfully deleted."
    respond_to do |format|
      format.html { redirect_to edit_question_path(@question) }
    end
  end

  def confirm_delete
    respond_to do |format|
      format.html
    end
  end
  
  private
  
    def retrieve_component
      @component = @user.components.find(params[:id])
    end

end