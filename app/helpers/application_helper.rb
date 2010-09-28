# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def current_user_home
    if no_user_or_anonymous_user
      return root_url
    else
      return url_for :controller=>'overview'
    end
  end
  
  protected
  
  def no_user_or_anonymous_user
    not current_user or current_user.anonymous?
  end
  
end
