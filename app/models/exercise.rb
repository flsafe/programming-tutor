class Exercise < ActiveRecord::Base
  has_many :completed_users, :through=>:grade_sheets, :source=>:user, :select=>'distinct users.*'
  has_many :grade_sheets, :after_add => :track_stats
  belongs_to :exercise_set
  
  validates_presence_of :title, :description
  
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
    return
    return unless grade_sheet.complete_set?
    grades = grade_sheet.grades_in_set
    avg = grades.inject {|sum, g| sum + g} / grades.count
    exercise_set.average_grade = new_average(exercise_set.average_grade, avg, exercise_set.completed_users.count)
  end
  
  def new_average(old_average, new_grade, n_new_users)
    return if n_new_users == 0
    old_average ||= 0
    old_average + (new_grade - old_average) / n_new_users
  end
end
