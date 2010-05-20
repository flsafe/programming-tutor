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
    syntax_check_job = SyntaxCheckJob.new(params[:code], current_user.id.to_s, params[:id])
    Delayed::Job.enqueue syntax_check_job
    
    render :partial=>'check_syntax_status', :layout=>false
  end
  
  def syntax_status
    
  end
end