class OverviewController < ApplicationController
  
  before_filter :require_user
  
  def index
    @exercises = Recomendation.for(current_user.id)
  end
end
