class PerformanceStatistic < ActiveRecord::Base
  
  validates_presence_of :user_id, :exercise_id, :name, :value
  
end