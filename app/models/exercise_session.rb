class ExerciseSession < ActiveRecord::Base
  belongs_to :user
  belongs_to :exercise
  
  validates_presence_of :user_id, :exercise_id
  
  def self.start_new_exercise_session(user_id, exercise_id)
    raise "That user is already doing an exercise!" if session_in_progress?(user_id, exercise_id)
    ExerciseSession.create! :user_id=>user_id, :exercise_id=>exercise_id
  end
  
  def self.session_in_progress?(user_id)
    ExerciseSession.find :first, :conditions=>{:user_id=>user_id}, :order=>'created_at DESC'
  end
  
  def self.end_exercise_session(user_id, exercise_id)
    session = ExerciseSession.find :first, :conditions=>{:user_id=>user_id, :exercise_id=>exercise_id}, :order=>'created_at DESC'
    raise "The user has no session in progress!" unless session
    session.destroy
  end
end