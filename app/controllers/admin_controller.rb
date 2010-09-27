class AdminController < ApplicationController
  before_filter :require_user, :require_admin
  
  def index
  
  end  
end