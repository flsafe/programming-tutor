require 'spec_helper'

describe TutorController do
  
  describe "get show" do
    
    it "retrieves the exercise to be displayed to the user" do
      exercise = mock_model(Exercise)
      Exercise.stub(:find_by_id).and_return(exercise)
      get 'show'
      assigns[:exercise].should == exercise
    end
    
    it "renders the show template" do
      get 'show'
      response.should render_template('show')
    end
  end
  
  describe "post check_syntax" do
    
    before(:each) do
      @syntax_checker = mock_model(SyntaxChecker).as_null_object
      SyntaxChecker.stub(:new).and_return(@syntax_checker)
      @code = "int main(){int i = 0; return 0;}"
    end
    
    it "gives the code from the text editor to the syntax checker" do
      @syntax_checker.should_receive(:check_syntax).with(@code)
      post :check_syntax, :code=>@code
    end
    
    it "shows the resulting syntax check message" do
      pending "This damn parital shows what I need" do
        @syntax_checker.stub(:check_syntax).and_return("syntax error")
        post :check_syntax
        response.should contain('syntax error')
      end
    end
    
    it "renders the syntax message partial" do
      @syntax_checker.stub(:check_syntax).and_return("syntax error")
      post :check_syntax
      response.should render_template('tutor/_syntax_message')
    end
  end
end
