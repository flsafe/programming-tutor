class StatsTracker
  def update;end

  def cumulative_average(object, field, new_value, new_count)
    object[field] = new_average(object[field], new_value, new_count)
  end
  
  def new_average(old_average, new_grade, n_new_users)
    return if n_new_users == 0
    old_average ||= 0
    old_average + (new_grade - old_average) / n_new_users
  end
end