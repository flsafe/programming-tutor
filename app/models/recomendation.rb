class Recomendation < ActiveRecord::Base
  validates_presence_of :user_id,  :exercise_recomendation_list

  composed_of :exercise_recomendation_list


  def self.for(user_id)
    rec = self.find(:first, 
                    :conditions=>['user_id=?', user_id],
                    :order=>"created_at DESC")
    if rec
      rec.exercise_recomendation_list.list
    else
      []
    end
  end
end
