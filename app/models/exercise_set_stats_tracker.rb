#TODO ExerciseSetTracker and ExerciseTracker violate DRY
class ExerciseSetStatsTracker < StatsTracker
  
  def update(set_grade_sheet)
    return if set_grade_sheet.retake?
    @grade_sheet  = set_grade_sheet
    @exercise_set = set_grade_sheet.exercise_set
    update_set_average
    @exercise_set.save
  end
  
  def update_set_average
    cumulative_average!(@exercise_set, :average_grade, @grade_sheet.grade, @exercise_set.completed_users.count)
  end
end