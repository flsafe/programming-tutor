module RatingLayoutHelper 

  def remote_rate_function(exercise_id, rating)
     remote_function(:url=>{:controller=>:ratings, 
                              :action=>:create,
                              :exercise_id=>exercise_id,
                              :rating=>rating})
  end
end
