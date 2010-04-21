class GradeSheet < ActiveRecord::Base
  belongs_to :user
  belongs_to :gradeable
  
  validates_presence_of :user, :grade, :gradeable
  
  def retake?
    n = GradeSheet.count :conditions=>["user_id=? AND gradeable_id=?", user.id, gradeable_id]
    n >= 2
  end
  
  def complete_set?
    finished_exercises = GradeSheet.count :conditions=>["user_id=? AND gradeable_id IN (?)", user.id, exercises_in_set], :select=>"distinct grade_sheets.gradeable_id"
    finished_exercises == exercises_in_set.count
  end
  
  private
  
  def exercises_in_set
    exercises = gradeable.exercise_set.exercises
    exercise_ids = exercises.collect {|e| e.id}
  end
end