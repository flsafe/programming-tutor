class GradeSheetsController < ApplicationController
  before_filter :authorize
  
  def show_user_grade_sheet
    @grade_sheet = GradeSheet.find(:first, :conditions=>['exercise_id=? AND user_id=?', params[:id], current_user.id], :order=>'created_at DESC')
    puts @grade_sheet
  end
end