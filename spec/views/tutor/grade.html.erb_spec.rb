require 'spec_helper'

describe  'tutor/grade.html.erb' do
  
  before(:each) do
    @grade_sheet  = mock_model(GradeSheet).as_null_object
    assigns[:grade_sheet] = @grade_sheet
  end
  
  it "displays a final grade" do
    @grade_sheet.stub(:grade).and_return(90)
    render
    response.should contain("Grade: 90")
  end
  
  it "displays the points earned for each test" do
    tests = {"Test 1"=>"50", "Test 2"=>"25"}
    @grade_sheet.stub(:tests).and_return(tests)
    render
    response.should contain("Test 1 50")
    response.should contain("Test 2 25")
  end
end