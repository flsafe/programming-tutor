Given /^I have not done any exercises$/ do
  @current_user.exercises = []
  @current_user.save
end

Then /^I should see a list of randomly recommended exercise sets$/ do
  response.should have_selector('#recommended_exercise_sets') do |recommended|
    recommended.should have_selector(".exercise_set") do |exercise_set|
      exercise_set.should have_selector(".exercise_set_statistics")
    end
  end
end


