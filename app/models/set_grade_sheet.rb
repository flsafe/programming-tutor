class SetGradeSheet < ActiveRecord::Base
  belongs_to :user
  belongs_to :exercise_set
  
  validates_presence_of :user, :exercise_set, :grade
  
  def retake?
    #TODO: Violation of DRY with SetGradeSheet.retake? and GradeSheet.retake?
    n = SetGradeSheet.count :conditions=>["user_id=? AND exercise_set_id=?", user.id, exercise_set.id]
    n >= 2
  end
end