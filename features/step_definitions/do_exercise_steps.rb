Given /^I am viewing the tutor page for "([^\"]*)"$/ do | title |
  ex = Exercise.find_by_title title
  visit "/tutor/show/#{ex.id}"
end

When /^I fill in the text editor with "([^\"]*)"$/ do |code|
  uncheck('edit_area_toggle_checkbox_textarea_1')
  fill_in("textarea_1", :with => code)
end

When /^The task is finished$/ do
  Delayed::Worker.new.work_off 
end

Then /^I should see my code$/ do
  within(:css, "#frame_textarea_1") do
    page.should have_content(@code)
  end
end