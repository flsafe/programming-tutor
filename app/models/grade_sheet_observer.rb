class GradeSheetObserver < ActiveRecord::Observer

  def after_save(grade_sheet)
    return if grade_sheet.retake?
    
    @exercise    = grade_sheet.exercise
    @grade_sheet = grade_sheet
    
    avg_grade = update_exercise_average_grade
    ExerciseStatistic.save_stat('average_grade', avg_grade, @exercise.id)
    
    avg_secs = update_exercise_average_time_taken
    ExerciseStatistic.save_stat('average_time_taken', avg_secs, @exercise.id)
  end
  
  def update_exercise_average_grade
    new_value = @grade_sheet.grade
    old_avg   = ExerciseStatistic.get_stat('average_grade', @exercise.id)
    new_count = @exercise.completed_users.count
    
    new_average(old_avg, new_value, new_count)
  end
  
  def update_exercise_average_time_taken
    new_value = @grade_sheet.time_taken
    old_avg   = ExerciseStatistic.get_stat('average_time_taken', @exercise.id)
    new_count = @exercise.completed_users.count
    
    new_average(old_avg, new_value, new_count)
  end
  
  def new_average(old_average, new_value, new_count)
    return if new_count == 0

    old_average ||= 0
    old_average + (new_value - old_average) / new_count
  end
  
end