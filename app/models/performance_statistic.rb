class PerformanceStatistic < ActiveRecord::Base
  
  validates_presence_of :user_id, :exercise_id, :name, :value
  
  def self.place_stat(user_id, exercise_id, name, value)
    PerformanceStatistic.clear_slot(user_id) #We assume the user can only do one exercise at a time, so clear the stats from the last exercise that was completed
    
    stat             = PerformanceStatistic.new
    stat.user_id     = user_id
    stat.exercise_id = exercise_id
    stat.name        = name
    stat.value       = value
    
    stat.save
  end
  
   def self.pop_performance_stats(user_id, names)
     stats = PerformanceStatistic.find(:all, :conditions=>{:user_id=>user_id, :name=>names}, :order=>"created_at DESC", :select=>:value, :group=>:name)
     stats
  end
  
  protected
  
  def self.clear_slot(user_id)
    PerformanceStatistic.delete_all :user_id=>user_id
  end
  
end