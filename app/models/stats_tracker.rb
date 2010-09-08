class StatsTracker
  def update;end

  def cumulative_average!(object, field, new_value, new_count)
    object[field] = new_average(object[field], new_value, new_count)
  end
  
  def cumulative_time_average!(object, time_field, new_minutes_value, new_seconds_value, new_count)
    puts "new_minutes_value: #{new_minutes_value}"
    puts "new_seconds_value: #{new_seconds_value}"
    
    avg_min  = new_average(object[time_field] && object[time_field].min, new_minutes_value, new_count)
    avg_secs = new_average(object[time_field] && object[time_field].sec, new_seconds_value, new_count)
    
    puts"New Average: #{avg_min}:#{avg_secs}"
    
    object[time_field] = Time.parse("00:#{avg_min}:#{avg_secs}")
  end
  
  def new_average(old_average, new_value, new_count)
    return if new_count == 0
    
    puts "old average: #{old_average}, new_value: #{new_value}, new_count: #{new_count}"
    
    old_average ||= 0
    old_average + (new_value - old_average) / new_count
  end
end