class User < ActiveRecord::Base
  ROLES_MASK = %w[admin user]
  easy_roles :roles_mask, :method=>:bitmask
  
  acts_as_authentic
  
  has_many :grade_sheets, :dependent=>:destroy
  has_many :completed_exercises, :through=>:grade_sheets, :source=>:exercise, :uniq=>true
  
  has_many :set_grade_sheets, :dependent=>:destroy
  has_many :completed_exercise_sets, :through=>:set_grade_sheets, :source=>:exercise_set, :uniq=>true
  
  attr_protected :roles_mask
  
  def grade_for?(exercise)
    conds = ['exercise_id=? AND user_id=?', exercise.id, self.id]
    gs    = GradeSheet.find(:first, :conditions=>conds, :order=>'created_at DESC')
    gs.grade if gs
  end
end
