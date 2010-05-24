# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  protect_from_forgery

  filter_parameter_logging :password, :password_confirmation
  
  helper_method :current_user_session, :current_user
  
  before_filter :authorize

  protected

  def authorize
    if not current_user_session
      flash[:notice] = 'You have to be logged in to do that!'
      redirect_to login_url
    end
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
end
