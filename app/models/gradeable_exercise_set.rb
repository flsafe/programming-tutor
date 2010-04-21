class GradeableExerciseSet < Gradeable
  
 def track_stats(grade_sheet)
   update_average_grade grade_sheet if grade_sheet.complete_set?
   self.save
 end
  
 private
  
  def update_average_grade(grade_sheet)
    return if grade_sheet.retake?
    exercises = grade_sheet.exercises
    self.average_grade = new_average(average_grade, grade_sheet.grade, completed_users.count)
  end

  def new_average(old_average, new_grade, n_new_users)
    return if n_new_users == 0
    old_average ||= 0
    old_average + (new_grade - old_average) / n_new_users
  end
end