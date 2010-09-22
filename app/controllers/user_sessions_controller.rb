class UserSessionsController < ApplicationController
  
  def new
    if current_user_session_and_not_anonymous
      redirect_to :controller=>:overview
    else
      @user_session = UserSession.new
    end
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      session = UserSession.find
      redirect_to :controller=>:overview
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    redirect_to "/"
  end
end
