class UserActionObserver

  @@dispatch_table = {:grade=>:save_performance_stats}
  
  def observe(tutor_controller)
    action = tutor_controller.action_name.to_sym
    send(@@dispatch_table[action], tutor_controller) if @@dispatch_table[action]
  end
  
  def save_performance_stats(tutor_controller)
    puts "*" * 50
    puts "***here!*****"
  end
end 