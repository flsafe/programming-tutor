class SyntaxCheckResult < ActiveRecord::Base
  def syntax_error?
    not error_message.blank?
  end
  
  def result
    if syntax_error?
      error_message
    else
      "No syntax errors detected!"
    end
  end
end