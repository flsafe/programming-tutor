
Then /^I should see a list of randomly recommended exercise sets$/ do
  page.should have_css('#recommended_exercise_sets') do |recommended|
    recommended.should have_css(".exercise_set") do |exercise_set|
      exercise_set.should have_css(".exercise_set_statistics")
    end
  end
end
