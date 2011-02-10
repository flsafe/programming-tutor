require 'spec_helper'

describe Exercise do
  before(:each) do
    @exercise ||= Factory.build(:exercise)
    @src_code     = 'source_code'
    @src_language = 'ruby'
  end

  describe "#sample?" do
    it "returns true if the exercise's title in in app_config['demo_exercise_titles']" do
      APP_CONFIG['demo_exercise_titles'] = ["My Exercise", "TestMe"]
      exercise = Factory.create :exercise, :title=>"My Exercise"
      exercise.sample?.should == true
    end

    it "returns false if the exercises title is not in APP_CONFIG[demo_exercise_titles]"do
      APP_CONFIG['demo_exercise_titles'] = ["Should not be found"]
      exercise = Factory.create :exercise, :title=>"Ex1"
      exercise.sample?.should == false
    end
  end
end
