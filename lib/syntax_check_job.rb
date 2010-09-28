class SyntaxCheckJob < Struct.new :code, :user_id, :exercise_id
  
  attr_accessor :code, :user_id, :exercise_id
  
  def perform
    error_message = Compiler.check_syntax(code)
    JobResult.place_result :user_id=>user_id, :exercise_id=>exercise_id, :data=>error_message, :job_type=>'syntax'
  end
  
  def self.get_latest_result(user_id, exercise_id)
    result = JobResult.get_latest_result(:user_id=>user_id, :exercise_id=>exercise_id, :job_type=>'syntax')
    if result
      syntax_error?(result) 
    end
  end
  
  protected 
  
  def self.syntax_error?(result)
    result.data =~ /syntax\s+error/i ? result.data : 'No syntax errors detected!'
  end
end