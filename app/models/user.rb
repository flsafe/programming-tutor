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
    if gs = grade_sheets.find(:first, :conditions=>['exercise_id=?', exercise.id], :order=>'created_at DESC') then
      gs.grade
    end
  end
end
