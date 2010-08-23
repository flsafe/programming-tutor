class OverviewController < ApplicationController
  
  before_filter :authorize
  
  def index
    @welcome_message = "Hey there #{current_user.username}! To start things off"
    @exercises   = Exercise.recommend(current_user.id, 2)
  end
end