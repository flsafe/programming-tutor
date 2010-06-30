require 'spec_helper'

describe ApplicationController do
  
  describe "#current_user_doing_exercise?" do
    
    it "returns an exercise id if the current user is doing an exercise" do
      session[:current_exercise_id] = 100
      controller.__send__('current_user_doing_exercise?').should == 100
    end
    
    it "returns nil if there is no exercise associated with the current session" do
      session[:current_exercise_id] = nil
      controller.__send__(:current_user_doing_exercise?).should == nil
    end
  end
  
  describe "current_exercise_start_time" do
    
    it "returns the current exercise start time" do
      session[:current_exercise_start_time] = 100
      controller.__send__(:current_exercise_start_time).should == 100
    end
    
    it "returns nill if there is no current exercise associated with the session" do
      session[:current_exercise_start_time] = nil
      controller.__send__(:current_exercise_start_time).should == nil
    end
  end
  
  describe "#set_current_exercise" do
    
    it "assigns to the session the current exercise_id and the time the exercise was started" do
      controller.__send__('set_current_exercise', 100, 100)
      session[:current_exercise_id].should == 100
      session[:current_exercise_start_time].should == 100
    end
  end
  
  describe "#cear_current_exercise" do
    
    it "clears the session info on the current exercsie" do
      session[:current_exercise_id]         = 100
      session[:current_exercise_start_time] = 100
      
      controller.__send__(:clear_current_exercise)
      session[:current_exercise_id].should         == nil
      session[:current_exercise_start_time].should == nil
    end
  end
end
