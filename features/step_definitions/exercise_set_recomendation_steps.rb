
Given /^I am a newly registered user with username "([^\"]*)"$/ do |username|
  @user = User.create :username=>username
end

Then /^I should see a list of randomly recommended exercise sets$/ do
  response.should have_selector('#recommended_exercise_sets') do |recommended|
        recommended.should have_selector(".exercise_set")
      end
end


