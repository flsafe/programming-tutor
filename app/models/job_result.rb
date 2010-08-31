class JobResult < ActiveRecord::Base
  
  validates_presence_of :user_id, :exercise_id
  
  def self.place_result(result)
    JobResult.clear_slot(result[:user_id], result[:exercise_id], result[:job_type])
    JobResult.create! result
  end
  
  def self.pop_result(conds)
    user_id     = conds[:user_id]
    exercise_id = conds[:exercise_id]
    type        = conds[:job_type]

    result = JobResult.find :first, :conditions=>{:user_id=>user_id, :exercise_id=>exercise_id, :job_type=>type}
    result.destroy if result
    result
  end
  
  protected
  
  def self.clear_slot(user_id, exercise_id, type)
     JobResult.delete_all(:user_id=>user_id, :exercise_id=>exercise_id, :job_type=>type)
  end
  
end