class Gradeable < ActiveRecord::Base
  has_many :grade_sheets, :after_add => :track_stats
  has_many :completed_users, :through=>:grade_sheets, :source=>:user, :select=>'distinct users.*'
  
  validates_presence_of :title, :description
  
  def track_stats(grade_sheet)
    update_average_grade(grade_sheet)
    self.save
  end
  
  private
  
  def update_average_grade(grade_sheet)
    return if grade_sheet.retake?
    self.average_grade = new_average(average_grade, grade_sheet.grade, completed_users.count)
  end
  
  def new_average(old_average, new_grade, n_new_users)
    return if n_new_users == 0
    old_average ||= 0
    old_average + (new_grade - old_average) / n_new_users
  end
  
  def retake?(grade_sheet)
    n = GradeSheet.count :conditions=>["user_id=? AND gradeable_id=?", grade_sheet.user.id, grade_sheet.gradeable_id]
    n >= 2
  end
end