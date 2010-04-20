module GradeableHelper
  def to_class(gradeable)
    ex_class = gradeable[:type] == "ExerciseSet" ? 'exercise_set' : 'exercise'
    status = current_user.grade_for?(gradeable) ? 'complete' : 'incomplete'
    "\"#{ex_class} #{status}\""
  end
end