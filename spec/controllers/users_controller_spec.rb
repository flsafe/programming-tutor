require 'spec_helper'

describe UsersController, "GET index" do
  context 'A user registers' do
    it 'redirects the newly registered user to thier home page' do
      user = mock_model(User).as_null_object
      user.stub(:save).and_return(true)
      User.stub(:new).and_return(user)
      
      post :create, :user=> user.attributes
      response.should redirect_to :controller=>'school'
    end
  end
end