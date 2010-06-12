class GradeSolutionResult < ActiveRecord::Base
  
  validates_presence_of :user_id, :exercise_id
  
  def self.get_result(user_id, exercise_id)
    result = GradeSolutionResult.find :first, :conditions=>['user_id=? AND exercise_id=?', user_id, exercise_id]
    if result
      result.destroy
    end
    result
  end
end