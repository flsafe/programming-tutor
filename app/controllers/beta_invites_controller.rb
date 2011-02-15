class BetaInvitesController < ApplicationController
  def new
    @beta_invite = BetaInvite.new
  end

  def create
    @beta_invite = BetaInvite.new params[:beta_invite]    
    if @beta_invite.save
      flash[:notice] = "We will send you a beta invite!"
    else
       render :action=>:new
    end
  end

  def redeem

  end
end
