module MenuHelper

  def show_menu?
    @url_black_list    ||= [ /^\/$/]
    
    @action_black_list ||= ['user_sessions:new',
                          'user_sessions:create',
                          'users:new',
                          'users:create']
    
    current_action        = "#{controller.controller_name}:#{controller.action_name}"
    not_black_list_url    = !(@url_black_list.detect {|no_show| request.request_uri =~ no_show } )
    not_black_list_action = !(@action_black_list.detect {|no_show| current_action == no_show} )
    
    not_black_list_url and not_black_list_action
  end
  
end