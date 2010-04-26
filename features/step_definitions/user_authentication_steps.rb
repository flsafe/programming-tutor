Given /^I am the registered user "([^\"]*)"$/ do |username|
  @current_user = Factory.create :user, :username=>username
end

Given /^I have admin privileges$/ do
  @current_user.add_role 'admin'
end

Given /^I am logged in as the user "([^\"]*)"$/ do |username|
  steps %Q{
    Given I am the registered user "#{username}"
    And I am on the login page
		When I fill in "username" with "frank"
		And I fill in "password" with "password"
		And I press "submit"
  }
end


