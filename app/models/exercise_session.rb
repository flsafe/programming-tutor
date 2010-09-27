class ExerciseSession < ActiveRecord::Base
  belongs_to :user
  belongs_to :exercise
  
  validates_presence_of :user_id, :exercise_id
end