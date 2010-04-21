class GradeSheet < ActiveRecord::Base
  belongs_to :user
  belongs_to :gradeable
  
  validates_presence_of :user, :grade, :gradeable
  
  def retake?
    n = GradeSheet.count :conditions=>["user_id=? AND gradeable_id=?", user.id, gradeable_id]
    n >= 2
  end
end