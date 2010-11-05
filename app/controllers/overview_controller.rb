class OverviewController < ApplicationController
  
  before_filter :require_user
  
  def index
    @welcome_message = "Hey there #{current_user.username}! To start things off"
    @exercises   = Recomendation.for(current_user.id) 
  end
end
