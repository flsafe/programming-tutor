class TutorController < ApplicationController
  def confirm
    @exercise = Exercise.find_by_id(params['id'])
  end
  
  def do_exercise
    @exercise = Exercise.find_by_id params[:id]
    @code     = params[:code]
    form_action
    render 'do_exercise'
  end
  
  private
  
  def form_action
    if params[:commit] == "Check Syntax"
      check_syntax params[:code]
    end
  end
  
  def check_syntax(code)
    syntax_checker  = SyntaxChecker.new
    @syntax_message = syntax_checker.check_syntax(code)
  end
end