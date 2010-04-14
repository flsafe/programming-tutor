class SchoolController < ApplicationController
  def index
    user = session[:current_user]
    @exercise_sets = ExerciseSet.recommend(user.id)
    @welcome_message = "Hey there #{user.username}! To start things off"
  end
end