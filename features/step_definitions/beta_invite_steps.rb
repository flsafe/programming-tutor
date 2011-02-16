Then /^there should be a new invite for "([^"]*)"$/ do |email|
  BetaInvite.count(:conditions => ['email = ?', email]).should == 1
end

Then /^an email should be sent out to "([^"]*)" containing the invite link$/ do |email|
  ActionMailer::Base.deliveries.count.should == 1
  @invite_email = ActionMailer::Base.deliveries.first
  @invite_email.to[0].should == email 

  @beta_invite = BetaInvite.find_by_email email
  match = @invite_email.body.match(/<a href="(.*)">/)
  match.should_not == nil 
  match[1].should == url_for(:controller=>:beta_invites, :action=>:redeem, :token=>@beta_invite.token, :host=>"blueberrytree.ws")
end

Given /^there exists an invite for "([^"]*)"$/ do |email|
  @beta_invite = BetaInvite.new_invite :email=>email
  @beta_invite.save
  @invite_email = BetaInviteMailer.create_invite(@beta_invite)
  BetaInviteMailer.deliver(@invite_email)
end

When /^I follow the test invite link$/ do
  visit(url_for :controller=>:beta_invites, :action=>:redeem, :token=>@beta_invite.token)
end

Then /^there should be a new user "([^"]*)" in the database$/ do |username|
  User.count(:conditions=>["username = ?", username]).should == 1
end

