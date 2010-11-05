require 'spec_helper'

describe OverviewController, "GET index" do
  
  context 'GET index a newly registered user browses their home page' do
    
    def current_user(stubs={})
      @current_user ||= stub_model(User, :username=>'frank')
    end
    
    before(:each) do
      controller.stub(:current_user).and_return(current_user)
    end
    
    it 'Assigns the recomendation exercises for the user' do
      Recomendation.should_receive(:for).with(current_user.id) 
      get :index
    end
    
    it 'assigns a welcome message' do
      get :index
      assigns[:welcome_message].should =~ /to start things off/i
    end
  end
end
