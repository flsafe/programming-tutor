module GradeableHelper
  def to_class(gradeable)
    ex_class = gradeable.respond_to?(:exercise_set) ? 'exercise' : 'exercise_set'
    status = current_user.grade_for?(gradeable) ? 'complete' : 'incomplete'
    "\"#{ex_class} #{status}\""
  end
end