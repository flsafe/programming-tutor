class TeachersAid
  
  def record_grade(grade_sheet)
    @user         = grade_sheet.user
    @grade_sheet  = grade_sheet
    @exercise_set = grade_sheet.exercise.exercise_set
    @exercise     = grade_sheet.exercise
    
    raise "Can't record grade without enough info! #{grade_sheet.errors.full_messages}" if grade_sheet.invalid?

    add_grade_sheet_to_exercise
    add_set_grade_sheet_to_exercise_set if @grade_sheet.complete_set?
  end
  
  private
  
  def add_grade_sheet_to_exercise
    @exercise.grade_sheets << @grade_sheet
  end
  
  def add_set_grade_sheet_to_exercise_set
    avg = average(@grade_sheet.grades_in_set)
    @exercise_set.set_grade_sheets.create! :grade=>avg, :user=>@user, :exercise_set=>@exercise_set
  end
  
  def average(grades)
    #Violation of DRY with average(). This function shows up in several places. Put it somewhere!
    grades.inject {|sum, g| sum+g} / grades.count
  end
end