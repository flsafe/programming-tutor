require 'eregex'

Given /^I am viewing the tutor page for "([^\"]*)"$/ do | title |
  ex = Exercise.find_by_title title
  ex.should_not == nil

  # Blueberry only displays an exercise if it is a 
  # recomended exercise or a retake. So here we
  # make sure the exercise is the recomended exercise
  steps %Q{
    Given there exists a recomendation for "#{title}"  
  }
  visit "/tutor/show/#{ex.id}"
end

When /^I fill in the text editor with "([^\"]*)"$/ do |code|
  if page.has_selector?('edit_area_toggle_checkbox_textarea_1')
    uncheck('edit_area_toggle_checkbox_textarea_1')
  end
  fill_in("textarea_1", :with => code)
end

When /^I fill in the text editor with the solution "([^\"]*)"$/ do |filename|
  f    = open("content/#{filename}", 'r')
  if page.has_selector?('edit_area_toggle_checkbox_textarea_1')
    uncheck('edit_area_toggle_checkbox_textarea_1')
  end
  fill_in("textarea_1", :with => f.read)
  f.close
end

When /^The task is finished$/ do
  Delayed::Worker.new.work_off 
end

Then /^I should see my code$/ do
  within(:css, "#frame_textarea_1") do
    page.should have_content(@code)
  end
end
