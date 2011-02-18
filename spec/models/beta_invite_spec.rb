require 'spec_helper'

describe BetaInvite do
  before(:each) do
    ActionMailer::Base.deliveries = []
  end

  describe "#send_if_space" do
    it "if there is space in the beta" do
      AppSetting.stub(:beta_capacity).and_return(1)
      @beta_invite = BetaInvite.new_invite :email=>'test@mail.com'
      @beta_invite.send_if_space
      ActionMailer::Base.deliveries.count.should == 1 
    end

    it "doesn't send the invite email if there is no more space in the beta" do
      AppSetting.stub(:beta_capacity).and_return(0)

      @beta_invite = BetaInvite.new_invite :email=>'test@mail.com'
      @beta_invite.send_if_space
      ActionMailer::Base.deliveries.count.should == 0
    end

    it "saves the invite to the db" do
      AppSetting.stub(:beta_capacity).and_return(1)
      @beta_invite = BetaInvite.new_invite :email=>'test@mail.com'
      @beta_invite.send_if_space
      BetaInvite.count.should == 1
    end
  end

  describe "BetaInvite.redeemed" do
    it "returns the number of beta invites that have been redeemed" do
      AppSetting.stub(:beta_capacity).and_return(3)
      3.times do |i| 
        @beta_invite = BetaInvite.new_invite :email=>"test#{i}@mail.com"
        @beta_invite.redeemed = 1
        @beta_invite.send_if_space
      end
      BetaInvite.redeemed.should == 3
    end
  end

  describe "BetaInvite.fill_to_capacity" do
    it "sends AppSetting.beta_capcity - BetaInvites.redeemed emails" do
      @beta_cap = 2 
      AppSetting.stub(:beta_capacity).and_return(@beta_cap)

      create_invites(10)
      redeem_invites(@beta_cap)

      @new_cap = @beta_cap + 5
      AppSetting.stub(:beta_capacity).and_return(@new_cap)

      BetaInvite.fill_to_capacity
      ActionMailer::Base.deliveries.count.should == (@new_cap - @beta_cap)
    end

    def create_invites(n)
      n.times do |i| 
        @beta_invite = BetaInvite.new_invite :email=>"test#{i}@mail.com"
        @beta_invite.send_if_space
      end
    end

    def redeem_invites(n)
      BetaInvite.find(:all, :limit=>n).each {|bi| bi.redeemed = 1 ; bi.save}
      ActionMailer::Base.deliveries = []
    end
  end
end
