class AdminController < ApplicationController
  before_filter :authorize, :check_current_user_is_admin
  def index
  
  end  
end