class SyntaxCheckResult < ActiveRecord::Base
  def syntax_error?
    not error_message.blank?
  end
  
  def message
    if syntax_error?
      error_message
    else
      "No syntax errors detected!"
    end
  end
  
  def self.get_result(user_id, exercise_id)
    result = SyntaxCheckResult.find :first, :conditions=>['user_id=? AND exercise_id=?', user_id, exercise_id]
    if result
      result.destroy
    end
    result
  end
end