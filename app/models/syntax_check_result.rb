class SyntaxCheckResult < ActiveRecord::Base
  def syntax_error?
    not error_message.blank?
  end
end