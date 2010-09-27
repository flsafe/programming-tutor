class AdminController < ApplicationController
  before_filter :require_user, :check_current_user_is_admin
  
  def index
  
  end  
end