class RatingLabelsController < ApplicationController

  before_filter :retrieve_user
  before_filter :retrieve_rating_label

  def destroy
    @rating_scale = @rating_label.rating_scale
    @rating_label.destroy
    respond_to do |format|
      flash[:notice] = "Rating label deleted."
      format.html { redirect_to edit_rating_scale_path(@rating_scale) }
    end
  end

  def confirm_delete
    respond_to do |format|
      format.html
    end
  end

  private
  
    def retrieve_rating_label
      @rating_label = @user.rating_labels.find(params[:id])
    end

end