class SyntaxCheckJob < Struct.new :code, :user_id, :exercise_id
  
  attr_accessor :code, :user_id, :exercise_id
  
  def perform
    begin
      compiler_message = Compiler.check_syntax(code)
      JobResult.place_result :user_id=>user_id, :exercise_id=>exercise_id, :data=>compiler_message, :job_type=>'syntax'
    rescue
      JobResult.place_result :user_id=>user_id, :exercise_id=>exercise_id, :error_message=>"An error occured, try again later", :job_type=>'syntax'
    end
  end
  
  def self.get_latest_result(user_id, exercise_id)
    result = JobResult.get_latest_result(:user_id=>user_id, :exercise_id=>exercise_id, :job_type=>'syntax')
    if result
      if result.error_message #job failed
        result.error_message
      elsif result.data == ""
        "No syntax errors detected!"
      elsif result.data != "" #compiler message 
        result.data 
      end
    end
  end
end
