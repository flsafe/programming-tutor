class GradeSheetsController < ApplicationController
  before_filter :authorize
  
  def show
    @grade_sheet = GradeSheet.find(params[:id])
  end
  
  def show_user_grade_sheet
    @exercise    = Exercise.find(params[:id])
    @grade_sheet = GradeSheet.find(:first, :conditions=>['exercise_id=? AND user_id=?', @exercise.id, current_user.id], :order=>'created_at DESC')
  end
  
  def show_all
    @exercise     = Exercise.find(params[:id])
    @grade_sheets = GradeSheet.find(:all, :conditions=>['exercise_id=?', @exercise.id], :order=>'created_at DESC', :group=>'username', :joins=>:user)
  end
  
end