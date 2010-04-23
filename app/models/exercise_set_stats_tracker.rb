class ExerciseSetStatsTracker < StatsTracker
  def update(set_grade_sheet)
    @grade_sheet  = set_grade_sheet
    @exercise_set = set_grade_sheet.exercise_set
    update_set_average
    @exercise_set.save
  end
  
  def update_set_average
    cumulative_average(@exercise_set, :average_grade, @grade_sheet.grade, @exercise_set.completed_users.count)
  end
end