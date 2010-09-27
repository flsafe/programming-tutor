# STAT NAMES
# exercise.average_grade
# exercise.average_time_taken
# user.time_taken
# user.total_time_taken

class Statistic < ActiveRecord::Base
  
  validates_presence_of :model_id, :name,  :value
  
  def self.get_stat(name, model_id)
    stat = Statistic.find :first, :conditions=>{:name=>name, :model_id=>model_id}, :select=>:value, :order=>'created_at DESC'
    stat && stat.value
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