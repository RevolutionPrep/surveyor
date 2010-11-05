class UsersController < ApplicationController

  before_filter :retrieve_user

  def new
    @user = User.new
    respond_to do |format|
      format.html
    end
  end

  def edit
    @user = current_user
    respond_to do |format|
      format.html
    end
  end

  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        flash[:notice] = "Registration successful! Welcome, #{@user.username}."
        format.html { redirect_to surveys_path }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = "Profile successfully updated."
        format.html { redirect_to surveys_path }
      else
        format.html { render :action => "edit" }
      end
    end
  end

end