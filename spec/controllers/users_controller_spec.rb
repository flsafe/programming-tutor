require 'spec_helper'

describe UsersController do
  
  before(:each) do
    current_user = stub_model(User, 'has_role?'=>false, 'is_admin?'=>false)
    controller.stub(:current_user).and_return(current_user)
  end
  
  context "the current user is not an admin" do
    
    it 'allows access to the new template' do
      get :new
      response.should render_template 'new'
    end
    
    it "does not allow access to the index" do
      get :index
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
      get :index
      flash[:error].should == "You don't have permission to do that!"
    end
  end
  
  context 'A user registers' do
    it 'redirects the newly registered user to thier home page' do
      user = stub_model(User, :save=>true).as_null_object
      User.stub(:new).and_return(user)
      post :create, :user=> user.attributes
      response.should redirect_to :controller=>:overview
    end
  end
end