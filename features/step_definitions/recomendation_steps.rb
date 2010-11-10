
Then /^the recomendation for "([^\"]*)" should be "([^\"]*)"$/ do |username, exercise_title|
  user = User.find_by_username(username)
  exercise = Exercise.find_by_title(exercise_title)
  recs = Recomendation.find(:first, 
    :conditions=>{:exercise_recomendation_list=>"#{exercise.id}", 
                  :user_id=>user.id})

  recs.should_not == nil 
end

Given /^there exists a recomendation for "([^\"]*)"$/ do |exercise_titles|
  exercises = Exercise.find :all,
    :conditions=>{:title=>exercise_titles.split},
    :select=>[:id]
  exercise_ids = exercises.map {|e| e.id}.join(',')
  recomended_ids = ExerciseRecomendationList.new(exercise_ids)

  sleep 1 # Logging in sets up a random rec. Make sure this one is the most resent

  Factory.create :recomendation, 
    :user_id=>@current_user.id,
    :exercise_recomendation_list=>recomended_ids
end

Given /^I note \/([^\/]*)\/$/ do |regex|
 regex = Regexp.new(regex)
 regex =~ page.body
 @noted = $1
end

Then /^I should always see what I noted on "([^\"]*)"$/ do |page_path|
 10.times do
  steps %Q{
    Given I am on #{page_path}
  }
  page.should have_content(@noted)
 end
end

