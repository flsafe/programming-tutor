# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  protect_from_forgery

  filter_parameter_logging :password, :password_confirmation
  
  helper_method :current_user_session, :current_user
  
  protected

  def authorize
    unless current_user
      flash[:notice] = 'You have to be logged in to do that!'
      redirect_to login_url
      false
    end
  end
  
  def check_current_user_is_admin
    unless current_user.is_admin?
      flash[:error] = "You don't have permission to do that!"
      redirect_to login_path
      false
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
  
  def current_user_doing_exercise?
    session[:current_exercise_id]
  end
  
  def current_exercise_start_time
    session[:current_exercise_start_time]
  end
  
  def set_current_exercise(exercise_id, exercise_start_time)
    session[:current_exercise_id]         = exercise_id
    session[:current_exercise_start_time] = exercise_start_time
  end
  
  def clear_current_exercise
    session[:current_exercise_id] = nil
    session[:current_exercise_start_time] = nil
  end
end
