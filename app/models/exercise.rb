class Exercise < Gradeable
  belongs_to :exercise_set, :class_name=>'ExerciseSet', :foreign_key=>'belongs_to'
end
