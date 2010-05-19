Given /^I am viewing the tutor page for "([^\"]*)"$/ do | title |
  ex = Exercise.find_by_title title
  visit exercise_path ex
end

When /^I fill in the text editor with a sample solution containing a syntax error$/ do
  @code = <<-CODE
    int main(){
      int i = 0
      return 0;
    }
  CODE
  uncheck('edit_area_toggle_checkbox_textarea_1')
  fill_in("textarea_1", :with => @code)
end

Then /^I should see my code$/ do
  within(:css, "#frame_textarea_1") do
    page.should have_content(@code)
  end
end


