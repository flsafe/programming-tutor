class UserActionObserver

  @@dispatch_table = {:grade=>:save_performance_stats}
  
  def observe(tutor_controller)
    action = tutor_controller.action_name.to_sym
    send(@@dispatch_table[action], tutor_controller) if @@dispatch_table[action]
  end
  
  def save_performance_stats(tutor_controller)
    elapsed_seconds = Time.now.to_i - tutor_controller.send(:current_exercise_start_time).to_i #Since we are an observer we can access protected methods and we won't be struct by lighting.
    current_user    = tutor_controller.send(:current_user)
    exercise_id     = tutor_controller.send(:current_exercise_id)
    
    Statistic.save_stat('time_taken', elapsed_seconds, 'performance_statistic', current_user.id)
  end
 
end 