class GradeSheet < ActiveRecord::Base
  belongs_to :user
  belongs_to :exercise
  
  validates_presence_of :user, :grade, :exercise
  
  def retake?
    n = GradeSheet.count :conditions=>["user_id=? AND exercise_id=?", user.id, exercise.id]
    n >= 2
  end
  
  def complete_set?
    finished_exercises = GradeSheet.count :conditions=>["user_id=? AND exercise_id IN (?)", user.id, ids_in_set], :select=>"distinct grade_sheets.exercise_id"
    finished_exercises == exercises_in_set.count
  end
  
  def grades_in_set
    grade_sheets = GradeSheet.find :all, :conditions=>["user_id=? AND exercise_id IN (?)", user.id, ids_in_set]
    return [] unless grade_sheets
    
    grade_sheets = grade_sheets.group_by(&:exercise_id)
    grades_list = []
    grade_sheets.each_pair do |id, grades|
      grades.sort! {|a,b| a.created_at <=> b.created_at}
      grades_list << grades[0].grade
    end
    grades_list
  end
  
  private
  
  def exercises_in_set
    exercise.exercise_set.exercises
  end
  
  def ids_in_set
    exercises_in_set.collect {|e| e.id}
  end
end