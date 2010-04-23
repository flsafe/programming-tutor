class StatsTracker
  def update;end

  def cumulative_average(object, field, new_value, new_count)
    object[field] = new_average(object[field], new_value, new_count)
  end
  
  def new_average(old_average, new_value, new_count)
    return if new_count == 0
    old_average ||= 0
    old_average + (new_value - old_average) / new_count
  end
end