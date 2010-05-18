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

  fill_in("code", :with => @code)
end


Then /^I should see my code$/ do
    page.should have_content(@code)
end


