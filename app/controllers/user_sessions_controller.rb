class UserSessionsController < ApplicationController

  def new
    @user_session = UserSession.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    respond_to do |format|
      if @user_session.save
        flash[:notice] = "Welcome, #{@user_session.username}!"
        format.html { redirect_to root_url }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    respond_to do |format|
      flash[:notice] = 'Goodbye.'
      format.html { redirect_to login_path }
    end
  end

end