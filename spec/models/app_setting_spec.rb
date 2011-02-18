require 'spec_helper'

describe AppSetting do
  before(:each) do
  end

  describe "#spec" do
    it "creates a new setting spec in the database" do
      AppSetting.spec("beta_capacity", 100)
      AppSetting.find_by_setting("beta_capacity").should_not == nil
    end
  end

  describe "#value" do
    it "returns a string if a string string was specd" do
      s = AppSetting.spec("work_dir", "/home/user1")
      s.value.should == "/home/user1" 
    end

    it "returns a int value if a int was specd" do
      s = AppSetting.spec("beta_capacity", 100)
      s.value.should == 100 
    end

    it "returns a float vlaue if float was specd" do
      s = AppSetting.spec('love', 100.10)
      s.value.should == 100.10 
    end
  end

  describe "AppSetting.beta_capacity" do
    it "returns the beata capacity" do
      AppSetting.spec('beta_capacity', 100)
      AppSetting.beta_capacity.should == 100
    end
  end
end
