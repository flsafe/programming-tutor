class SchoolController < ApplicationController
  def index
    @welcome_message = "Hey there #{current_user.username}! To start things off"
    @exercise_sets = ExerciseSet.recommend(current_user.id, 2)
  end
end