module MenuHelper

  # Urls that should not show menu  
  @@url_black_list = [ /^\/$/, /^\/motivation$/]
  
  # Controller:action combos that should not show the menu    
  @@action_black_list = ['user_sessions:new',
                        'user_sessions:create',
                        'users:new',
                        'users:create',
                        'demo:index']

  def show_menu?
    current_action = "#{controller.controller_name}:#{controller.action_name}"
    not_in_black_list_url = !(@@url_black_list.detect {|no_show| request.request_uri =~ no_show } )
    not_in_black_list_action = !(@@action_black_list.detect {|no_show| current_action == no_show} )
    
    not_in_black_list_url and not_in_black_list_action
  end
  
end