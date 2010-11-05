class Recomendation < ActiveRecord::Base
  validates_presence_of :user_id,  :exercise_recomendation_list

  composed_of :exercise_recomendation_list


  def self.for(user_id)
    recs = self.find(:all, 
                    :conditions=>['user_id=?', user_id],
                    :order=>"created_at DESC",
                    :limit=>1)

    recs = to_exercises(merge_all(recs))
    if recs.empty?
      random_exercise
    else
      recs  
    end
  end

  protected

  def self.merge_all(recs)
    recs = recs.reduce([]) do |accu, rec| 
      accu.concat rec.exercise_recomendation_list.list
    end
  end

  def self.to_exercises(recs)
   Exercise.find(:all,
                 :conditions=>{:id=>recs})
  end

  def self.random_exercise
    exercises = Exercise.find :all
    if exercises.empty?
      []
    else
      [ exercises[ rand(exercises.count) ] ]
    end
  end
end
