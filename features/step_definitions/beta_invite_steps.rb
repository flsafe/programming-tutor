Then /^there should be a new invite for "([^"]*)"$/ do |email|
  BetaInvite.count(:conditions => ['email = ?', email]).should == 1
end

