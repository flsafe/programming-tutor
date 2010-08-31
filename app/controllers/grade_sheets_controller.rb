class GradeSheetsController < ApplicationController
  before_filter :authorize
  
  def show_user_grade_sheet
    @exercise    = Exercise.find(params[:id])
    @grade_sheet = GradeSheet.find(:first, :conditions=>['exercise_id=? AND user_id=?', @exercise.id, current_user.id], :order=>'created_at DESC')
  end
end