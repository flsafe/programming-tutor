# TODO: As I add more user action stats I will need a pattern here
# For now here is a quick implementation

class UserActionObserver

  @@dispatch_table = {:grade=>:save_performance_stats}
  
  def observe(tutor_controller)
    action = tutor_controller.action_name.to_sym
    send(@@dispatch_table[action], tutor_controller) if @@dispatch_table[action]
  end
  
  def save_performance_stats(tutor_controller)
    current_user = tutor_controller.send(:current_user)
    exercise_session = current_user.exercise_session
    
    start_time = Time.parse(exercise_session.created_at.to_s)
    elapsed_seconds = Time.now.to_i - start_time.to_i
    
    Statistic.save_stat('user.time_taken', current_user.id, elapsed_seconds)
  end
 
end 