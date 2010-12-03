class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :all
  helper_method :current_user

  rescue_from ActiveRecord::RecordNotFound, :with => :access_denied

  protected

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end

    def retrieve_user
      unless @user = current_user
        flash[:notice] = "You must be logged in to access this page"
        redirect_to login_url
        return false
      end
    end

    def access_denied
      flash[:notice] = "You do not have access to this asset."
      redirect_to root_url
    end

end