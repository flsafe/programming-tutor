
Given /^I am a newly registered user with username "([^\"]*)"$/ do |username|
  @student = Student.create :username=>username
end
