class SyntaxCheckJob < Struct.new :code, :user_id, :exercise_id
  
  attr_accessor :code, :user_id, :exercise_id, :error_message
  
  def perform
    @error_message = `echo "#{code}" | gcc -x c -fsyntax-only - 2>&1`
    SyntaxCheckResult.create! self.attributes
  end
end