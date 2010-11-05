class RatingScalesController < ApplicationController

  before_filter :retrieve_user
  before_filter :retrieve_rating_scale, :except => [:index, :new, :create]

  def index
    @question = @user.questions.find(session[:question_id]) rescue nil
    @rating_scales = @user.rating_scales
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
    @rating_scale = @user.rating_scales.new
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
    @rating_scale = @user.rating_scales.new(params[:rating_scale])
    respond_to do |format|
      if @rating_scale.save
        flash[:notice] = "Rating scale created."
        format.html { redirect_to edit_rating_scale_path(@rating_scale) }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @rating_scale.update_attributes(params[:rating_scale])
        if params[:commit] == "Add Label"
          @rating_scale.rating_labels.new
          format.html { render :edit }
        else
          flash[:notice] = "Rating scale updated."
          format.html { redirect_to rating_scale_path(@rating_scale) }
        end
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @rating_scale.destroy
    respond_to do |format|
      flash[:notice] = "Rating scale deleted."
      format.html { redirect_to rating_scales_path }
    end
  end

  def confirm_delete
    @questions = @user.questions.find_all_by_rating_scale_id(params[:id])
    @surveys = @questions.collect{ |question| question.section.survey }.uniq
    respond_to do |format|
      format.html
    end
  end
  
  private
  
    def retrieve_rating_scale
      @rating_scale = @user.rating_scales.find(params[:id])
    end

end