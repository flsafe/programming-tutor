require 'spec_helper'

describe JobResult do
  
  before(:each) do
    @stub_user     = stub_model(User)
    @stub_exercise = stub_model(Exercise)
    @example_result = {:user_id=>@stub_user.id, :exercise_id=>@stub_exercise.id, :data=>'ok', :error_message=>'error'}
  end
  
  describe "#place_result" do
    
    it "clears any job results in the db with the given user_id and exercise_id (clears the slot)" do
      JobResult.should_receive(:delete_all).with(:user_id=>@stub_user.id, :exercise_id=>@stub_exercise.id)
      JobResult.place_result(:user_id=>@stub_user.id, :exercise_id=>@stub_exercise.id, :data=>"okay")
    end
    
    it "inserts a job result object into the db with the param info(places a result in the slot)" do
      JobResult.should_receive(:create!).with(@example_result)
      JobResult.place_result(@example_result)
    end
  end
  
  
  describe "#pop_result" do
    
    it "retrieves a job result object with the given user_id and exercise_id" do
      JobResult.should_receive(:find).with(:first, :conditions=>{:user_id=>@stub_user.id, :exercise_id=>@stub_exercise.id})
      JobResult.pop_result(:user_id=>@stub_user.id, :exercise_id=>@stub_exercise.id)
    end
    
    it "deletes the record from the database (removes the result from the slot)" do
      JobResult.should_receive(:delete_all).with(:user_id=>@stub_user.id, :exercise_id=>@stub_exercise.id)
      JobResult.place_result(@example_result)
    end
    
  end
end
