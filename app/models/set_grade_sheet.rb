class SetGradeSheet < ActiveRecord::Base
  belongs_to :user
  belongs_to :exercise_set
  
  validates_presence_of :user, :exercise_set
end