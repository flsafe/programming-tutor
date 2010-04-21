class GradeableExercise < Gradeable
  
 def track_stats(grade_sheet)
    return if grade_sheet.retake?
    
    update_exercise_average_grade(grade_sheet)
    update_exercise_set_average_grade grade_sheet
    self.save
  end
  
  private
  
  def update_exercise_average_grade(grade_sheet)
    self.average_grade = new_average(average_grade, grade_sheet.grade, completed_users.count)
  end
  
  def update_exercise_set_average_grade(grade_sheet)
    
  end
  
  def new_average(old_average, new_grade, n_new_users)
    return if n_new_users == 0
    old_average ||= 0
    old_average + (new_grade - old_average) / n_new_users
  end
end