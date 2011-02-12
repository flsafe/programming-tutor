class Recomendation < ActiveRecord::Base
  validates_presence_of :user_id,  :exercise_recomendation_list

  composed_of :exercise_recomendation_list

  def self.for(user) 
    new_plate = remove_completed_exercises_from_plate(user)
    if new_plate.empty
      user.plate.replace( recomended_or_random_exercies(user) )
    end
    user.plate
  end

  def self.recomended?(user, exercise)
    recomended_exercises = get_recomendations(user)
    recomended_exercises.detect {|e| e == exercise} != nil
  end

  protected

  def self.remove_completed_exercises_from_plate(user)
    user.plate.delete(user.completed_exercises) 
  end

  def self.recomended_or_random_exercies(user)
    exercises = get_recomendations(user)
    if exercises.empty?
      exercises = random_exercises(user) 
    end
    exercises 
  end

  def self.get_recomendations(user)
   # TODO: The recomendations have a special order. They are 
   # sorted by highest predicted rating. merge_all and to exercises
   # don't perserve this order. If you'd like to make more than
   # just one recomendation, then this needs to be fixed
    recs = self.find(:all, 
                    :conditions=>['user_id=? AND exercise_recomendation_list<>?', user.id, ""],
                    :order=>"created_at DESC",
                    :limit=>1)
    recs = to_exercises(merge_all(recs))
  end

  def self.recomend_random_exercises(user)
    to_exercises( recomend(user, random_exercises(user)) )
  end

  def self.recomend(user, exercises)
    ex_ids = exercises.map{|e| e.id}.join ','
    recs = ExerciseRecomendationList.new(ex_ids)
    Recomendation.create! :user_id=>user.id,
                          :exercise_recomendation_list=>recs
    ex_ids
  end

  def self.merge_all(recs)
    recs = recs.reduce([]) do |accu, rec| 
      accu.concat rec.exercise_recomendation_list.list
    end
  end

  def self.to_exercises(recs)
   Exercise.find_all_by_id(recs)
  end

  def self.random_exercises(user)
    completed_exercises = user.completed_exercises.map {|e| e.id}
    completed_exercises << 0 if completed_exercises.empty? # The query below won't work right with an empty list
    exercise_ids = Exercise.find(:all, 
                              :select=>:id, 
                              :conditions=>["finished = 1 AND id NOT IN (?)", completed_exercises])
    if not exercise_ids.empty?
      random_exercise_id = exercise_ids[ rand(exercise_ids.count)].id
      return [ Exercise.find(random_exercise_id) ]
    else
      return []
    end
  end
end
