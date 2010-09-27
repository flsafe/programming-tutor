class User < ActiveRecord::Base
  ROLES_MASK = %w[admin user]
  easy_roles :roles_mask, :method=>:bitmask
  
  acts_as_authentic
  
  has_many :grade_sheets, :dependent=>:destroy
  has_many :completed_exercises, :through=>:grade_sheets, :source=>:exercise, :uniq=>true #todo: What does this mean?
  has_many :exercise_sessions, :dependent=>:destroy, :before_add=>:limit_one_exercise_session
  
  attr_protected :roles_mask, :anonymous
  
  def grade_for?(exercise)
    conds = ['exercise_id=? AND user_id=?', exercise.id, self.id]
    gs    = GradeSheet.find(:first, :conditions=>conds, :order=>'created_at DESC')
    gs.grade if gs
  end
  
  def get_stat(name)
    Statistic.get_stat("user.#{name}", self.id) || 0
  end
  
  def start_exercise_session(exercise_id)
    exercise_sessions << ExerciseSession.new(:exercise_id=>exercise_id)
  end
  
  def exercise_session_in_progress?
    exercise_session != nil
  end
  
  def exercise_session
    exercise_sessions.find :first
  end
  
  def current_exercise
    session = exercise_session
    session.exercise
  end
  
  def end_exercise_session
    session = exercise_session
    raise "The user doesn't have an exercise session" unless session
    session.destroy
  end
  
  def limit_one_exercise_session(exercise_session)
    raise "The user can't have more than one exercise session at a time!" if exercise_session_in_progress?
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
