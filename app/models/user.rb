class User < ActiveRecord::Base
  ROLES_MASK = %w[admin user]
  easy_roles :roles_mask, :method=>:bitmask
  
  acts_as_authentic
  
  has_many :grade_sheets
  has_many :completed_exercises, :through=>:grade_sheets, :source=>:exercise
  
  has_many :set_grade_sheets
  has_many :completed_exercise_sets, :through=>:set_grade_sheets, :source=>:exercise_set
  
  attr_protected :roles_mask
  
  def grade_for?(exercise)
    if is_exercise? exercise
      grade_sheets_or_set_grade_sheets =  :grade_sheets
      conds                            = ['exercise_id=?', exercise.id]
    else
      grade_sheets_or_set_grade_sheets = :set_grade_sheets
      conds = ['exercise_set_id=?', exercise.id]
    end
    gs = send(grade_sheets_or_set_grade_sheets).find(:first, :conditions=>conds, :order=>'created_at DESC')
    gs.grade if gs
  end
  
  protected
  
  def is_exercise?(ex)
    ex.respond_to?(:exercise_set)
  end
end
