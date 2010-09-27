class OverviewController < ApplicationController
  
  before_filter :require_user
  
  def index
    @welcome_message = "Hey there #{current_user.username}! To start things off"
    @exercises   = Exercise.recommend(current_user.id, 4)
  end
end