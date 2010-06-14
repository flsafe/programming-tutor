require 'spec_helper'

describe GradeSolutionJob do
  
  def current_user
    @user ||= stub_model(User)
  end
  
  def code
    "int main(){ return 0;}"
  end
  
  def exercise
    @exercise ||= mock_model(Exercise)
  end
  
  def template
    @template ||= mock_model(SolutionTemplate).as_null_object
  end
  
  def unit_test
    @unit_test ||= mock_model(UnitTest).as_null_object
  end
  
  def grade_sheet
    @grade_sheet ||= mock_model(GradeSheet).as_null_object
  end
  
  def result
    @result ||= mock_model(GradeSolutionResult).as_null_object
  end
  
  def ta
    @ta ||= mock_model(TeachersAid).as_null_object
  end
  
  def job
    @job ||= GradeSolutionJob.new code, current_user.id, exercise.id
  end
  
  describe "#perform" do
    
    before(:each) do
      SolutionTemplate.stub(:find).and_return(template)
      UnitTest.stub(:find).and_return(unit_test)
      
      unit_test.stub(:run_on).and_return({:error => nil})

      TeachersAid.stub(:new).and_return(ta)
    end
    
    it "gets the solution template associated with the exercise" do
      SolutionTemplate.should_receive(:find).with(:first, {:conditions=>['exercise_id=? AND src_language=?', exercise.id, 'c']}).and_return(template)
      job.perform
    end
    
    it "fills in the solution template with the user program code" do
      template.should_receive(:fill_in).with(code)
      job.perform
    end
    
    it "gets the unit test associated with the exercise" do
      UnitTest.should_receive(:find).with(:first, {:conditions=>['exercise_id=? AND src_language=?', exercise.id, 'rb']})
      job.perform
    end
    
    it "Runs the unit test on the solution template" do
      solution_code = "solution code"
      template.stub(:filled_in_src_code).and_return(solution_code)
      
      template.should_receive(:filled_in_src_code)
      unit_test.should_receive(:run_on).with(template, template.id, solution_code).and_return({})
      job.perform
    end
    
    it "Saves a grade solution result object to the database" do
      GradeSheet.stub(:new).and_return(grade_sheet)
      GradeSolutionResult.stub(:new).and_return(result)
      
      GradeSolutionResult.should_receive(:new).with(:user_id=>current_user.id, :exercise_id=>exercise.id, :error_message => nil, :grade_sheet_id=>grade_sheet.id)
      result.should_receive(:save!)
      job.perform 
    end
    
    it "saves the grade sheet to the database" do
      GradeSheet.stub(:new).and_return(grade_sheet)
      unit_test.stub(:run_on).and_return(reslt = {'error' => nil, 'grade' => 100, 'test1' => '20 points'})
      
      GradeSheet.should_receive(:new).with(:user_id => current_user.id, :exercise_id => exercise.id, :src_code => code, :unit_test_results => reslt, :grade => reslt['grade'])
      ta.should_receive(:record_grade).with(grade_sheet)
      job.perform
    end
  end
end