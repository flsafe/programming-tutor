require 'spec_helper'

describe OverviewController, "GET current_plate" do
    
  before(:each) do
    @current_user = Factory.create(:user, :username=>'frank')
    controller.stub(:current_user).and_return(@current_user)
  end

  it "retrieves the user's current plate" do
    @current_user.should_receive(:plate_json)
    get "current_plate"
  end

  it "returns the current users plate in json form" do
    @current_user.stub(:plate_json).and_return("{plate:[{ex_id: 1, grade: 100, order: 1}]}")
    get "current_plate"
    response.body.should == @current_user.plate_json
  end
end

describe OverviewController, "post new_plate" do
    
  before(:each) do
    @current_user = Factory.create(:user, :username=>'frank')
    controller.stub(:current_user).and_return(@current_user)
  end

  it "assigns a new plate to the current user" do
    @current_user.should_receive('new_plate')
    post :new_plate
  end
end
