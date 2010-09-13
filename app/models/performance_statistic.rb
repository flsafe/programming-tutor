class PerformanceStatistic < ActiveRecord::Base
  
  validates_presence_of :user_id, :exercise_id, :name, :value
  
  def self.place_stat(user_id, exercise_id, stat_name, value)
    PerformanceStatistic.clear_slot(user_id, stat_name) #We assume the user can only do one exercise at a time, so clear the stats from the last exercise that was completed
    PerformanceStatistic.create! :user_id=>user_id, :exercise_id=>exercise_id, :name=>stat_name, :value=>value
  end
  
   def self.get_latest_stats(user_id, stat_names)
     stats = PerformanceStatistic.find(:all, :conditions=>{:user_id=>user_id, :name=>stat_names}, :order=>"created_at DESC", :select=>'name, value', :group=>:name)
     stats
  end
  
  protected
  
  def self.clear_slot(user_id, stat_name)
    PerformanceStatistic.delete_all :user_id=>user_id, :name=>stat_name
  end
  
end