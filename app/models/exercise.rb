class Exercise < ExerciseGradeable
  belongs_to :exercise_set, :class_name=>'ExerciseSet', :foreign_key=>'belongs_to'
end
