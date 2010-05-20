class SyntaxCheckJob < Struct.new :code, :user_id, :exercise_id
  
  attr_accessor :code, :user_id, :exercise_id, :error_message
  
  def perform
    self.error_message = `echo "#{code}" | gcc -x c -fsyntax-only - 2>&1`
    SyntaxCheckResult.create! :user_id=>user_id, :exercise_id=>exercise_id, :error_message=>error_message
  end
end