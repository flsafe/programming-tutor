class TutorController < ApplicationController
  def confirm
    @exercise = Exercise.find_by_id(params['id'])
  end
  
  def show
    @exercise = Exercise.find_by_id params[:id]
  end
  
  def grade
    
  end
  
  def check_syntax
    syntax_checker = SyntaxChecker.new
    syntax_message = syntax_checker.check_syntax(params[:code])
    render :partial=>'syntax_message', :object=>syntax_message, :layout=>false
  end
end