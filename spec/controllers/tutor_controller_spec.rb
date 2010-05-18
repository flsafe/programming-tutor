require 'spec_helper'

class SyntaxChecker
end

describe TutorController do
  
  describe "post form_action" do

    describe  "Check Syntax" do
      before(:each) do
        @syntax_checker = mock(SyntaxChecker).as_null_object
        SyntaxChecker.stub(:new).and_return(@syntax_checker)
        @code = "int main(){int i = 0; return 0;}"
      end
      
      it "gives the code from the text editor to the syntax checker" do
        @syntax_checker.should_receive(:check_syntax).with(@code)
        post :do_exercise, :commit=>"Check Syntax", :code=>@code
      end
      
      it "assigns a syntax message to display to the user" do
        @syntax_checker.stub(:check_syntax).and_return("syntax error")
        post :do_exercise, :commit=>"Check Syntax"
        assigns[:syntax_message].should == "syntax error"
      end
      
      it "assigns the code to be displayed" do
        post :do_exercise, :commit=>"Check Syntax", :code=>@code
        assigns[:code].should == @code
      end
      
      it "renders the tutor/do_exercise template" do
        post :do_exercise, :commit=>"Check Syntax"
        response.should render_template('do_exercise')
      end
    end
  end
end
