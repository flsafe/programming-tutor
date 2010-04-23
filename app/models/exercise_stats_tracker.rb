class ExerciseStatsTracker < StatsTracker
  
  def update(grade_sheet)
    return if grade_sheet.retake?
    @exercise    = grade_sheet.exercise
    @grade_sheet = grade_sheet
    update_exercise_average_grade
    @exercise.save
  end
  
  def update_exercise_average_grade
    cumulative_average(@exercise, :average_grade, @grade_sheet.grade, @exercise.completed_users.count)
  end
end