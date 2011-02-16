Then /^there should be a new invite for "([^"]*)"$/ do |email|
  BetaInvite.count(:conditions => ['email = ?', email]).should == 1
end

Then /^an email should be sent out to "([^"]*)" containing the invite link$/ do |email|
  emails = ActionMailer::Base.deliveries
  emails.detect {|e| e.to[0] == email}.should == true
end

