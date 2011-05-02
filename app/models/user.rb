class User < ActiveRecord::Base
  ROLES_MASK = %w[admin user]
  easy_roles :roles_mask, :method=>:bitmask
  
  acts_as_authentic
  
  has_many :grade_sheets, :dependent=>:destroy, :after_add=>:track_completed_sets
  has_many :completed_exercises, :through=>:grade_sheets, :source=>:exercise, :group=>:id, :select=>'exercises.id, exercises.title, exercises.description', :order=>'exercises.created_at DESC'
  has_and_belongs_to_many :completed_sets, :class_name=>"ExerciseSet"
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

  def make_plate_if_empty(reload = false)
    if plate(reload).empty?
      next_plate = ExerciseSet.random_incomplete_set_for(self)
      if next_plate
        plate.push(next_plate.exercises)
      else
        plate.push([])
      end
    end
  end

  def plate_json(reload=false)
    make_plate_if_empty 
    exercises = plate(reload).map do |ex|
      { :ex_id => ex.id,
        :order => ex.order,
        :grade => grade_for(ex)
      }
    end
    {:plate => exercises}
  end

  def new_plate(reload=false)
    if plate(reload).all? {|e| grade_for(e) == 100}
      next_plate = ExerciseSet.random_incomplete_set_for(self)
      if next_plate 
        plate.replace(next_plate.exercises)
      else
        plate.replace([])
      end
    end
    plate_json
  end

  def in_plate?(exercise)
    self.plate.detect {|e| e == exercise} != nil
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

  protected

  def track_completed_sets(gs)
    if gs.complete_set?
      completed_sets.push(gs.exercise.exercise_set)
    end
  end
end
