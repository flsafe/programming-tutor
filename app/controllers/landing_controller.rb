class LandingController < ApplicationController
  
  def index
    if current_user_session_and_not_anonymous
      redirect_to :controller=>:overview
    end
  end
end
