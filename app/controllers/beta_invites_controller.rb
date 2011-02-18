class BetaInvitesController < ApplicationController
  def new
    @beta_invite = BetaInvite.new
  end

  def create
    @beta_invite = BetaInvite.new_invite params[:beta_invite]
    if @beta_invite.save
      @beta_invite.send_if_space 
    else
       render :action=>:new
    end
  end

  def redeem
    @beta_invite = BetaInvite.find_by_token(params[:token]) 
    if @beta_invite
      @user = User.new
      @user.email = @beta_invite.email
      session[:beta_invite] = @beta_invite.token 
      render :template=>"/users/new" 
    else
      redirect_to root_path
    end
  end
end
