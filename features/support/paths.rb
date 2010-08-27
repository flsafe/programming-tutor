module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    when /the home\s?page/
      '/'
      
    when /login\s?page/
        '/login'
        
    when /exercise sets page/
      exercise_sets_path
      
    when /create exercise page/
      new_exercise_path
      
    when /the exercise index page/
      exercises_path
      
    when /the register page/
      new_user_path
      
    when /my exercises page/
      url_for :controller=>'exercises', :action=>'user_index', :id=>'done'
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
