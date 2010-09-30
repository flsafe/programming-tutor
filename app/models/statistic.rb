# STAT NAMES
# exercise.average_grade
# exercise.average_time_taken (seconds)
# user.time_taken
# user.total_time_taken (seconds)

class Statistic < ActiveRecord::Base
  
  validates_presence_of :model_id, :name,  :value
  
  def self.get_stat(name, model_id)
    stat = Statistic.find :first, :conditions=>{:name=>name, :model_id=>model_id}, :select=>:value, :order=>'created_at DESC'
    stat.value || 0.0 if stat
  end
  
  def self.save_stat(name, model_id, value)
    stat = Statistic.find :first, :conditions=>{:name=>name, :model_id=>model_id}
    if stat
      stat.value = value
      stat.save!
    else
      Statistic.create! :name=>name, :value=>value, :model_id=>model_id
    end
  end
end