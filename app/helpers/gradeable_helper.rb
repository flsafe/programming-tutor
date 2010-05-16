module GradeableHelper
  def to_class(gradeable)
    obj_type = get_type(gradeable)
    status   = user_completed?(gradeable)
    "\"#{obj_type} #{status}\""
  end
  
  private
  
  def get_type(e)
    e.respond_to?(:exercise_set) ? 'exercise' : 'exercise_set'
  end
  
  def user_completed?(e)
    current_user.grade_for?(e) ? 'complete' : 'incomplete'
  end
end