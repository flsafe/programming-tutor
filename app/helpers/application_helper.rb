# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def current_user_home
    return if not current_user
    
    if current_user.anonymous?
      link_to 'Home', root_url
    else
      link_to 'Home', :controller=>'overview'
    end
  end
  
end
