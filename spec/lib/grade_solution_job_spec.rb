require 'spec_helper'

describe GradeSolutionJob do
  
  def code
    "int main(){return 0;}"
  end
  
  def current_user
    @current_user ||= stub_model(User)
  end
  
  def exercise
    @exercise ||= stub_model(Exercise)
  end
  
   def grade_sheet
    @grade_sheet ||= stub_model(GradeSheet).as_null_object.as_new_record
  end
  
   def grade_solution_result
    @grade_solution_result ||= stub_model(GradeSolutionResult).as_null_object
  end
  
   def job
    @job ||= GradeSolutionJob.new code, current_user.id, exercise.id
  end
  
   def ta
    @ta ||= mock(TeachersAid).as_null_object
  end
  
  def template
    @template ||= stub_model(SolutionTemplate, :fill_in=>true, 'syntax_error?'=>false).as_null_object
  end
  
  def unit_test
    @unit_test ||= stub_model(UnitTest).as_null_object
  end
  
  describe "#perform" do
    
    before(:each) do
      SolutionTemplate.stub(:find_by_exercise_id).and_return(template)
      
      grade_sheet
      GradeSheet.stub(:new).and_return(grade_sheet)
      
      UnitTest.stub(:find_by_exercise_id).and_return(unit_test)
      unit_test.stub(:run_on).and_return({:grade=>90})
      
      ta
      TeachersAid.stub(:new).and_return(ta)
      
      grade_solution_result
      GradeSolutionResult.stub(:new).and_return(grade_solution_result)
    end
    
    it "creates a new solution template with the user code" do
      template.should_receive(:fill_in).with(code)
      job.perform
    end
    
    it "checks the template for a syntax error" do
      template.should_receive(:syntax_error?)
      job.perform
    end
    
    it "runs the unit test on the template" do
      unit_test.should_receive(:run_on).with(template).and_return({})
      job.perform
    end
    
    it "creates a new grade sheet from the unit test results" do
      results = {:grade=>90}
      unit_test.stub(:run_on).and_return results
      grade_sheet.should_receive(:unit_test_results=).with(results).once
      job.perform
    end
    
    it "assigns the solution code to the grade sheet" do
      grade_sheet.should_receive(:src_code=).with(code)
      job.perform
    end
    
    it "records the grade sheet for the user" do
      ta.should_receive(:record_grade).with(grade_sheet)
      job.perform
    end
    
    it "it saves a grade_job_result to the database with a success message" do
      GradeSolutionResult.should_receive(:new).with(:error_message=>nil, :grade_sheet_id=>grade_sheet.id)
      job.perform
    end
    
    context "the template has a syntax error" do
      before(:each) do
        template.stub(:syntax_error?).and_return(true)
      end
      
      it "Saves a grade_job_result with the message describing the syntax error" do
        GradeSolutionResult.should_receive(:new).with(:error_message=>"Your solution did not compile! Check your syntax.", :grade_sheet_id=>nil)
        job.perform
      end
      
      it "saves the grade sheet" do
        grade_solution_result.should_receive(:save)
        job.perform
      end
      
      it "does not record a grade sheet" do
        ta.should_not_receive(:record_grade)
      end
    end
    
    context "the unit test results indicate that the solution timed out" do
      before(:each) do
        unit_test.stub(:run_on).and_return({:error=>:timed_out})
      end
      
      it "creates grade_job_result with the message describing the solution timed out" do
        GradeSolutionResult.should_receive(:new).with(:error_message=>:timed_out, :grade_sheet_id=>nil)
        job.perform
      end
      
      it "saves the grade_solution_result" do
        grade_solution_result.should_receive(:save)
        job.perform
      end

      it "does not save a grade sheet" do
        grade_sheet.should_not_receive(:save)
        job.perform
      end
    end
  end
end