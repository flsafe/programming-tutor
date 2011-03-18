require 'net/http'

class Rating < ActiveRecord::Base
  validates_presence_of :user_id, :exercise_id, :rating
  validates_uniqueness_of :exercise_id, :scope=>[:user_id]

  def self.to_value(rating_str)
    rating_str = rating_str.sub(/\-/, '_')
    rating = APP_CONFIG['rating_values'][rating_str]
    rating.to_f
  end

  def self.has_rated?(user, exercise)
    Rating.find_by_user_id_and_exercise_id(user.id, exercise.id) != nil 
  end
end
