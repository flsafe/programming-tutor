class Recomendation < ActiveRecord::Base
  validates_presence_of :user_id,  :exercise_recomendation_list

  composed_of :exercise_recomendation_list


  def self.for(user_id)
    recs = self.find(:all, 
                    :conditions=>['user_id=?', user_id],
                    :order=>"created_at DESC",
                    :limit=>10)
    unless recs.empty?
      recs.reduce([]) do |accu, rec| 
        accu.concat rec.exercise_recomendation_list.list
      end
    else
      []
    end
  end
end
