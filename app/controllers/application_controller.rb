# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  protect_from_forgery

  filter_parameter_logging :password, :password_confirmation
  
  helper_method :current_user_session, :current_user_session_and_not_anonymous, :current_user, :current_user_home
  
  protected

  def require_user
    unless current_user_session_and_not_anonymous
      flash[:error] = 'You have to be logged in to do that!'
      redirect_to login_url
    end
  end
  
  def require_user_or_create_anonymous
    unless current_user_session
      u = User.new_anonymous
      u.save(false)
      @current_user_session = UserSession.find
      @current_user = current_user
    end
  end
  
  def require_admin
    unless current_user_session_and_not_anonymous and current_user.is_admin?
      flash[:error] = "You don't have permission to do that!"
      redirect_to login_path
    end
  end
  
  def destroy_anonymous
    if current_user and current_user.anonymous?
      current_user.destroy
      current_user_session.destroy
      @current_user_session = nil
    end
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def current_user_home
    if no_user_or_anonymous_user
      return root_url
    else
      return url_for :controller=>'overview'
    end
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user_session_and_not_anonymous
    current_user and not current_user.anonymous?
  end

  def no_user_or_anonymous_user
    not current_user or current_user.anonymous?
  end
end
