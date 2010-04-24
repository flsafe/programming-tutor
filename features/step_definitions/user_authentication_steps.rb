Given /^I am the registered user "([^\"]*)"$/ do |username|
  params = {
    :username=>username,
    :email=>'user@mail.com',
    :password=>'password',
    :password_confirmation=>'password'
  }

  #@current_user = User.create!(params)
  @current_user = Factory.create :user, :username=>username
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


