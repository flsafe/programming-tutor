require 'spec_helper'

describe OverviewController, "GET index" do
  
  context 'GET index a newly registered user browses their home page' do
    
    def current_user(stubs={})
      @current_user ||= stub_model(User, :username=>'frank')
    end
    
    before(:each) do
      controller.stub(:current_user).and_return(current_user)
    end
    
    it 'gets exercise sets for the user' do
      exercises = [stub_model(Exercise)]
      Exercise.should_receive(:recommend).with(current_user.id, 2).and_return(exercises)
      get :index
    end
    
    it 'assigns a welcome message' do
      get :index
      assigns[:welcome_message].should =~ /to start things off/i
    end
  end
end