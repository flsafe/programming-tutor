class Statistic < ActiveRecord::Base
  
  validates_presence_of :model_id, :model_name, :name,  :value
  
  def self.get_stat(name, model_name, model_id)
    stat = Statistic.find :first, :conditions=>{:name=>name, :model_name=>model_name, :model_id=>model_id}, :select=>:value
    stat && stat.value
  end
  
  def self.save_stat(name, value, model_name, model_id)
    stat = Statistic.find :first, :conditions=>{:name=>name, :model_name=>model_name, :model_id=>model_id}
    if stat
      stat.value = value
      stat.save
    else
      Statistic.create! :name=>name, :value=>value, :model_name=>model_name, :model_id=>model_id
    end
  end
end