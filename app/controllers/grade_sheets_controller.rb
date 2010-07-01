class GradeSheetsController < ApplicationController
  before_filter :authorize
  
  def show_user_grade_sheet
    @exercise    = Exercise.find_by_id params[:id]
    @grade_sheet = GradeSheet.find(:first, :conditions=>['exercise_id=? AND user_id=?', params[:id], current_user.id], :order=>'created_at DESC')
  end
end