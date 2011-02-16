Then /^there should be a new invite for "([^"]*)"$/ do |email|
  BetaInvite.count(:conditions => ['email = ?', email]).should == 1
end

Then /^an email should be sent out to "([^"]*)" containing the invite link$/ do |email|
  ActionMailer::Base.deliveries.count.should == 1
  e = ActionMailer::Base.deliveries.first
  e.to[0].should == email 
end

