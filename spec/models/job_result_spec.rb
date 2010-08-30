require 'spec_helper'

describe JobResult do
  
  before(:each) do
    @stub_user     = stub_model(User)
    @stub_exercise = stub_model(Exercise)
    @example_result = {:user_id=>@stub_user.id, :exercise_id=>@stub_exercise.id, :data=>'ok', :error_message=>'error', :job_type=>'grade'}
  end
  
  describe "#place_result" do
    
    it "clears any job results in the db with the given user_id and exercise_id (clears the slot)" do
      attributes = {:user_id=>@stub_user.id, :exercise_id=>@stub_exercise.id, :job_type=>'grade'}
      JobResult.should_receive(:delete_all).with(attributes)
      JobResult.place_result(@example_result)
    end
    
    it "inserts a job result object into the db with the param info(places a result in the slot)" do
      JobResult.should_receive(:create!).with(@example_result)
      JobResult.place_result(@example_result)
    end
  end
  
  
  describe "#pop_result" do
    
    it "retrieves a job result object with the given user_id and exercise_id type" do
      JobResult.should_receive(:find).with(:first, :conditions=>{:user_id=>@stub_user.id, :exercise_id=>@stub_exercise.id, :job_type=>'grade'})
      JobResult.pop_result(:user_id=>@stub_user.id, :exercise_id=>@stub_exercise.id, :job_type=>'grade')
    end
    
    it "deletes the record from the database (removes the result from the slot)" do
      JobResult.should_receive(:delete_all).with(:user_id=>@stub_user.id, :exercise_id=>@stub_exercise.id, :job_type=>'grade')
      JobResult.place_result(@example_result)
    end
    
  end
end
