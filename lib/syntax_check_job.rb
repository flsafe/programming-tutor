class SyntaxCheckJob < Struct.new :code, :user_id, :exercise_id
  def perform
    error_message = `echo "#{code}" | gcc -x c -fsyntax-only - 2>&1`
  end
end