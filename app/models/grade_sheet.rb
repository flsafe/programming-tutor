class GradeSheet < ActiveRecord::Base
  belongs_to :user
  belongs_to :exercise
  
  validates_presence_of :user, :grade, :exercise, :unit_test_results, :src_code, :minutes
  
  def retake?
    completed = GradeSheet.count_grade_sheets(user, exercise)
    completed >= 2
  end
  
  def complete_set?
    completed_exercises = GradeSheet.count_distinct_sibling_grade_sheets(user, exercise)
    exercises_in_set    = GradeSheet.siblings(exercise).count
    completed_exercises == exercises_in_set
  end
  
  def grades_in_set
    grade_sheets = GradeSheet.sibling_grade_sheets(user, exercise)
    return [] unless grade_sheets
    filter_retakes(grade_sheets)
  end
  
  def unit_test_results_hash
    @hash ||= YAML.load(unit_test_results).with_indifferent_access
  end

  protected
  
  def filter_retakes(grade_sheets)
    gs_no_retakes = get_oldest_grade_sheets(grade_sheets)
    gs_no_retakes.collect(&:grade)
  end
  
  def get_oldest_grade_sheets(grade_sheets)
    gs_by_exercise_id = grade_sheets.group_by(&:exercise_id)
    oldest = []
    gs_by_exercise_id.each_pair do |exercise_id, grade_sheets_in_ex|
      oldest << oldest_grade_sheet_for(grade_sheets_in_ex)
    end
    oldest
  end
  
  def oldest_grade_sheet_for(grade_sheets_in_ex)
    grade_sheets_in_ex.sort! {|a,b| a.created_at <=> b.created_at}
    grade_sheets_in_ex[0]
  end
  
  def self.siblings(exercise)
    exercise.exercise_set.exercises
  end
  
  def self.sibling_ids(exercise)
    GradeSheet.siblings(exercise).collect {|e| e.id}
  end
  
  def self.count_grade_sheets(user, exercise)
    GradeSheet.count :conditions=>["user_id=? AND exercise_id=?", user.id, exercise.id]
  end
  
  def self.count_distinct_sibling_grade_sheets(user, exercise)
    GradeSheet.count :conditions=>["user_id=? AND exercise_id IN (?)", user.id, GradeSheet.sibling_ids(exercise)], :select=>"distinct grade_sheets.exercise_id"
  end
  
  def self.sibling_grade_sheets(user, exercise)
    GradeSheet.find :all, :conditions=>["user_id=? AND exercise_id IN (?)", user.id, GradeSheet.sibling_ids(exercise)]
  end
end