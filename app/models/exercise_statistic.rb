class ExerciseStatistic < ActiveRecord::Base
  
  validates_presence_of :exercise_id, :name, :value
  
  def self.get_stat(name, exercise_id)
    stat = ExerciseStatistic.find :first, :conditions=>{:name=>name, :exercise_id=>exercise_id}, :select=>:value
    stat && stat.value
  end
  
  def self.save_stat(name, value, exercise_id)
    ExerciseStatistic.create! :name=>name, :value=>value, :exercise_id=>exercise_id
  end
end