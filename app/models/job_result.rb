class JobResult < ActiveRecord::Base
  
  validates_presence_of :user_id, :exercise_id
  
  def self.place_result(result)
    JobResult.clear_slot(result[:user_id], result[:exercise_id])
    JobResult.create result
  end
  
  def self.pop_result(conds)
    user_id     = conds[:user_id]
    exercise_id = conds[:exercise_id]
    JobResult.clear_slot(user_id, exercise_id)
    JobResult.find :first, :conditions=>{:user_id=>user_id, :exercise_id=>exercise_id}
  end
  
  protected
  
  def self.clear_slot(user_id, exercise_id)
     JobResult.delete_all(:user_id=>user_id, :exercise_id=>exercise_id)
  end
  
end
