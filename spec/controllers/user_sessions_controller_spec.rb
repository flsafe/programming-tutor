require 'spec_helper'
 
describe UserSessionsController do
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid"

  
  it "create action should redirect when model is valid"

  
  it "destroy action should destroy model and redirect to index action"

end
