class SyntaxCheckJob < Struct.new :code, :user_id, :exercise_id
  
  attr_accessor :code, :user_id, :exercise_id
  
  def perform
    error_message = Compiler.check_syntax(code)
    SyntaxCheckResult.delete_all ['user_id = ? AND exercise_id = ?', user_id, exercise_id]
    SyntaxCheckResult.create! :user_id=>user_id, :exercise_id=>exercise_id, :error_message=>error_message
    JobResult.place_result :user_id=>user_id, :exercise_id=>exercise_id, :data=>error_message
  end
  
  def pop_result(conds)
    user_id, exercise_id = conds[:user_id], conds[:exercise_id]
    result = JobResult.pop_result(:user_id=>user_id, :exercise_id=>exercise_id)
    if result
      syntax_error?(result) 
    end
  end
  
  protected 
  
  def syntax_error?(result)
    result.data =~ /syntax\s+error/i ? result.data : 'No syntax error detected!'
  end
end