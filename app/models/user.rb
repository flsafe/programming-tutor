class User < ActiveRecord::Base
  ROLES_MASK = %w[admin user]
  easy_roles :roles_mask, :method=>:bitmask
  
  acts_as_authentic
  
  has_many :grade_sheets, :dependent=>:destroy
  has_many :completed_exercises, :through=>:grade_sheets, :source=>:exercise, :uniq=>true
  
  attr_protected :roles_mask, :anonymous
  
  def grade_for?(exercise)
    conds = ['exercise_id=? AND user_id=?', exercise.id, self.id]
    gs    = GradeSheet.find(:first, :conditions=>conds, :order=>'created_at DESC')
    gs.grade if gs
  end
  
  def get_stat(name)
    Statistic.get_stat("user.#{name}", self.id) || 0
  end
  
  def self.new_anonymous
    user = User.new
    user.username = 'anonymous'
    user.anonymous = true
    user.crypted_password = ''
    user.password_salt = ''
    user.persistence_token = ''
    user.email = ''
    user
  end
end
