class Rating < ActiveRecord::Base
  validates_presence_of :user_id, :exercise_id, :rating
  validates_uniqueness_of :exercise_id, :scope=>[:user_id]
end
