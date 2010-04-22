class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :grade_sheets
  has_many :completed_exercise_sets, :through=>:grade_sheets, :source=>:exercise_set
  
  def grade_for?(exercise_set)
    if gs = grade_sheets.find(:first, :conditions=>['exercise_id=?', exercise_set.id], :order=>'created_at DESC') then
      gs.grade
    end
  end
end
