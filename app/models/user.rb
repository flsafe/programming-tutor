class User < ActiveRecord::Base
  ROLES_MASK = %w[admin user]
  easy_roles :roles_mask, :method=>:bitmask
  
  acts_as_authentic
  
  has_many :grade_sheets, :dependent=>:destroy
  has_many :completed_exercises, :through=>:grade_sheets, :source=>:exercise, :uniq=>true #todo: What does this mean?
  has_and_belongs_to_many :plate, :class_name=>"Exercise"
  has_one :exercise_session, :dependent=>:destroy
  
  attr_protected :roles_mask, :anonymous, :password_salt, :persistence_token
  
  def grade_for(exercise)
    gs = grade_sheets.find_by_exercise_id(exercise, :order=>"created_at DESC")
    gs.grade if gs
  end

  def retake?(exercise)
    raise "nil exercise" if exercise == nil
    grade_sheets.count(:conditions=>["exercise_id = ?", exercise.id]) > 1 
  end
  
  def get_stat(name)
    Statistic.get_stat("user.#{name}", id) || 0
  end
  
  def start_exercise_session(exercise)
    create_exercise_session(:exercise=>exercise, :user=>self)
  end
  
  def exercise_session_in_progress?
    exercise_session != nil
  end
  
  def current_exercise
    exercise_session.exercise if exercise_session
  end
  
  def end_exercise_session
    raise "The user doesn't have an exercise session" unless exercise_session
    exercise_session.destroy
    exercise_session = nil
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
