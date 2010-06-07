require 'spec_helper'

describe  'tutor/grade.html.erb' do
  before(:each) do
    @grade_sheet  = stub_model(GradeSheet)
    assigns[:grade_sheet] = @grade_sheet
  end
  
  it "displays a final grade" do
    @grade_sheet.stub(:grade).and_return(90)
    render
    response.should have_selector("grade_sheet") do |gs|
      gs.should contain("Grade: 90")
    end
  end
  
  
end