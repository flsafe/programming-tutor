class Recomendation < ActiveRecord::Base
  validates_presence_of :user_id,  :exercise_recomendation_list

  composed_of :exercise_recomendation_list


  def self.for(user_id)
    recs = get_recomendations(user_id)
    if recs.empty?
     recomend_random_exercises(user_id)
    else
      recs  
    end
  end

  protected

  def self.get_recomendations(user_id)
    recs = self.find(:all, 
                    :conditions=>['user_id=? AND exercise_recomendation_list<>?', user_id, ""],
                    :order=>"created_at DESC",
                    :limit=>10)
    recs = to_exercises(merge_all(recs))
  end

  def self.recomend_random_exercises(user_id)
    to_exercises( recomend(user_id, random_exercises) )
  end

  def self.recomend(user_id, exercises)
    ex_ids = exercises.map{|e| e.id}.join ','
    recs = ExerciseRecomendationList.new(ex_ids)
    [Recomendation.create! :user_id=>user_id,
      :exercise_recomendation_list=>recs]
  end

  def self.merge_all(recs)
    recs = recs.reduce([]) do |accu, rec| 
      accu.concat rec.exercise_recomendation_list.list
    end
  end

  def self.to_exercises(recs)
   Exercise.find(:all,
                 :conditions=>{:id=>recs})
  end

  def self.random_exercises
    exc = Exercise.count
    unless exc == 0
        [ Exercise.find :first, :offset=>rand(exc) ]
    else
        []
    end
  end
end
