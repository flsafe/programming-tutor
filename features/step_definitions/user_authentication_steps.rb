
Given /^I am the registered user "([^\"]*)"$/ do |username|
  params = {
    :username=>username,
    :email=>'user@mail.com',
    :password=>'password',
    :password_confirmation=>'password'
  }
  @user = User.create!(params)
end
