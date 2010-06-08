class SyntaxCheckJob < Struct.new :code, :user_id, :exercise_id
  
  attr_accessor :code, :user_id, :exercise_id
  
  def perform
    error_message = SyntaxChecker.syntax_error?(code)
    puts SyntaxCheckResult.delete_all ['user_id = ? AND exercise_id = ?', user_id, exercise_id]
    puts SyntaxCheckResult.create! :user_id=>user_id, :exercise_id=>exercise_id, :error_message=>error_message
  end
end