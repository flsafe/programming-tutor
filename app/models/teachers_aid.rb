class TeachersAid
  def record_grade(grade_sheet)
    @exercise = grade_sheet.exercise
    @exercise.grade_sheets << grade_sheet
    track_stats grade_sheet
    @exercise.save
  end
  
  private
  
  def track_stats(grade_sheet)
    return if grade_sheet.retake?
    update_exercise_average_grade(grade_sheet)
    update_set_average grade_sheet
  end

  def update_exercise_average_grade(grade_sheet)
    avg_grade   = @exercise.average_grade
    users_count = @exercise.completed_users.count
    grade       = grade_sheet.grade
    @exercise.average_grade = new_average(avg_grade, grade, users_count)
  end
  
  def update_set_average(grade_sheet)
    return if not grade_sheet.complete_set?
    
    grades = grade_sheet.grades_in_set

    avg    = grades.inject {|sum, g| sum + g} / grades.count
    set    = @exercise.exercise_set
    set.set_grade_sheets.create! :user=>grade_sheet.user, :grade=>avg, :exercise_set=>set
    
    puts "#grades: #{grades.to_s}\navg:#{avg}\ncompl users: #{set.completed_users.count}"
    set.average_grade = new_average(set.average_grade, avg, set.completed_users.count)
    puts "set average: #{set.average_grade}"
    set.save
  end
  
  def new_average(old_average, new_grade, n_new_users)
    return if n_new_users == 0
    old_average ||= 0
    old_average + (new_grade - old_average) / n_new_users
  end
end