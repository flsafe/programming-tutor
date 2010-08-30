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
      SolutionTemplate.stub_chain(:for_exercise, :written_in).and_return([template])
      UnitTest.stub_chain(:for_exercise, :written_in).and_return([unit_test])
      
      unit_test.stub(:run_on).and_return({:error => nil})

      TeachersAid.stub(:new).and_return(ta)
    end
    
    it "creates a work directory where the solution will be compiled and the unit test executed" do
      FileUtils.stub(:mkdir_p).and_return true
      FileUtils.should_receive(:mkdir_p).with(APP_CONFIG['work_dir'])
      job.perform
    end
    
    it "gets the solution template associated with the exercise" do
      SolutionTemplate.stub_chain(:for_exercise, :written_in).and_return([])
      SolutionTemplate.should_receive(:for_exercise).with(exercise.id).and_return(@mock = mock("scope"))
      @mock.should_receive(:written_in).with('c')
      job.perform
    end
    
    it "fills in the solution template with the user program code" do
      template.should_receive(:fill_in).with(code)
      job.perform
    end
    
    it "gets the unit test associated with the exercise" do
      UnitTest.stub_chain(:for_exercise, :written_in).and_return([])
      UnitTest.should_receive(:for_exercise).with(exercise.id).and_return(@mock = mock('scope'))
      @mock.should_receive(:written_in).with('rb')
      job.perform
    end
    
    it "runs the unit test on the solution template" do
      solution_code = "solution code"
      template.stub(:fill_in).and_return(solution_code)
      unit_test.should_receive(:run_on).with(solution_code).and_return({})
      job.perform
    end
    
    it "places the job result in the db on successful save of the gradesheet" do
      job.stub(:save_grade_sheet).and_return(1)
      JobResult.should_receive(:place_result).with(:user_id=>current_user.id, :exercise_id=>exercise.id, :error_message => nil, :data=>'OK')
      job.perform 
    end
    
    it "places a error result in the db on unsuccessful save of the gradesheeet" do
      job.stub(:save_grade_sheet).and_return(nil)
      JobResult.should_receive(:place_result).with(:user_id=>current_user.id, :exercise_id=>exercise.id, :error_message=>"Grade sheet could not be saved")
      job.perform
    end
    
    it "saves the grade sheet to the database" do
      GradeSheet.stub(:new).and_return(grade_sheet)
      unit_test.stub(:run_on).and_return(reslt = {'error' => nil, 'grade' => 100, 'test1' => '20 points'}.with_indifferent_access)
      
      GradeSheet.should_receive(:new).with(:user_id => current_user.id, :exercise_id => exercise.id, :src_code => code, :unit_test_results => reslt, :grade => reslt['grade'])
      ta.should_receive(:record_grade).with(grade_sheet)
      job.perform
    end
    
    context "when the unit test returns an error, it places and error result in the db" do
      it "it posts an error message" do
        #these are the two errors the unit test can return
        errors = [{:error=>:did_not_compile}, {:error=>:no_result_returned}]
          errors.each do |r|
          unit_test.stub(:run_on).and_return(r)
          JobResult.should_receive(:place_result).with(:user_id=>current_user.id, :exercise_id=>exercise.id, :error_message=>r[:error])
          job.perform
        end
      end
    end
    
    context "when an exception is thrown before the results are returned" do
      it "posts the error to the database" do
        SolutionTemplate.stub(:find).and_raise("A mock exception")
        JobResult.should_receive(:place_result)
        job.perform
      end
    end
  end
end