# TODO: A pattern is going to be needed here as I add stats. For now 
# here is a simple implementation for stats tracking

class GradeSheetObserver < ActiveRecord::Observer

  def after_save(grade_sheet)
    return if grade_sheet.retake?
    
    @exercise    = grade_sheet.exercise
    @grade_sheet = grade_sheet
    
    avg_grade = update_exercise_average_grade
    Statistic.save_stat('exercise.average_grade', @exercise.id, avg_grade)
    
    avg_secs = update_exercise_average_time_taken
    Statistic.save_stat('exercise.average_time_taken',@exercise.id, avg_secs)
    
    total_time_taken = update_total_time_taken
    Statistic.save_stat('user.total_time_taken', @grade_sheet.user_id, total_time_taken)
  end
  
  def update_exercise_average_grade
    new_value = @grade_sheet.grade
    old_avg   = Statistic.get_stat('exercise.average_grade', @exercise.id)
    new_count = @exercise.completed_users.count
    
    new_average(old_avg, new_value, new_count)
  end
  
  def update_exercise_average_time_taken
    new_value = @grade_sheet.time_taken
    old_avg   = Statistic.get_stat('exercise.average_time_taken', @exercise.id)
    new_count = @exercise.completed_users.count
    
    new_average(old_avg, new_value, new_count)
  end
  
  def update_total_time_taken
    new_value     = @grade_sheet.time_taken
    current_value = Statistic.get_stat('user.total_time_taken', @grade_sheet.user_id) || 0
    current_value + new_value
  end
  
  def new_average(old_average, new_value, new_count)
    return if new_count == 0

    old_average ||= 0
    old_average + ((new_value - old_average) / new_count.to_f)
  end
end