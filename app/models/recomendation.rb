class Recomendation < ActiveRecord::Base
  validates_presence_of :user_id,  :exercise_recomendation_list

  composed_of :exercise_recomendation_list

  def self.for(user_id)
    recomended_exercises = get_recomendations(user_id)
    if recomended_exercises.empty?
     recomend_random_exercises(user_id)
    else
      recomended_exercises  
    end
  end

  def self.recomended?(user_id, exercise_id)
    recomended_exercises = get_recomendations(user_id)
    recomended_exercises.detect {|e| e.id == exercise_id.to_i} != nil
  end

  protected

  def self.get_recomendations(user_id)
    recs = self.find(:all, 
                    :conditions=>['user_id=? AND exercise_recomendation_list<>?', user_id, ""],
                    :order=>"created_at DESC",
                    :limit=>1)
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
   # TODO: The recomendations have a special order. They are 
   # sorted by highest predicted rating. This function does
   # not perserve this order. If you'd like to make more than
   # just one recomendation, then this needs to be fixed
   Exercise.find_all_by_id(recs)
  end

  def self.random_exercises
    finished_exercises = Exercise.find( :all, :select=>:id, :conditions=>{:finished=>1})
    if finished_exercises.count > 0
      random_exercise_id = finished_exercises[ rand(finished_exercises.count)].id
      [ Exercise.find(random_exercise_id) ]
    else
      []
    end
  end
end
