class BetaInvitesController < ApplicationController
  def new
    @beta_invite = BetaInvite.new
  end

  def create
    @beta_invite = BetaInvite.create_invite params[:beta_invite]
    if @beta_invite.save
      BetaInviteMailer.deliver_invite(@beta_invite)
      render :action=>:create
    else
       render :action=>:new
    end
  end

  def redeem

  end
end
