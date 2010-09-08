class ExerciseStatsTracker < StatsTracker
  
  def update(grade_sheet)
    raise "Can't track stats on the grade sheet because it is not vaild!\n #{grade_sheet.errors}" unless grade_sheet.valid?
    
    return if grade_sheet.retake?
    
    @exercise    = grade_sheet.exercise
    @grade_sheet = grade_sheet
    
    update_exercise_average_grade
    update_exercise_average_seconds
    @exercise.save
  end
  
  def update_exercise_average_grade
    cumulative_average!(@exercise, :average_grade, @grade_sheet.grade, @exercise.completed_users.count)
  end
  
  def update_exercise_average_seconds
    cumulative_average!(@exercise, :average_seconds, @grade_sheet.time_taken, @exercise.completed_users.count)
  end
end