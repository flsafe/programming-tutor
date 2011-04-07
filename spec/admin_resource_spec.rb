require 'spec_helper'

shared_examples_for "controller for admin resource" do
  
  describe "the current user is not an admin" do
    before(:each) do
      current_user = stub_model(User, 'has_role?'=>false, 'is_admin?'=>false)
      controller.stub(:current_user).and_return(current_user)
    end
    
    it "does not allow access to the index" do
      get :index
      response.should redirect_to login_path
    end
    
    it "renders the login page if new is requested" do
      get :new
      response.should redirect_to login_path
    end
    
    it "renders the login page if create is posted" do
      post :create
      response.should redirect_to login_path
    end
    
    it "renders the login page if edit is requested" do
      get :edit
      response.should redirect_to login_path
    end
    
    it "renders the login page if put" do
      put :update
      response.should redirect_to login_path
    end
    
    it "renders the login page if delete" do
      delete  :delete, :id=>'1'
      response.should redirect_to login_path
    end
    
    it "flashes the permssions message"do
      get :new
      flash[:error].should == "You don't have permission to do that!"
    end
  end
end

