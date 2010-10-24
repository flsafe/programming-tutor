class Rating < ActiveRecord::Base
  validates_presence_of :user_id, :exercise_id, :rating
  validates_uniqueness_of :exercise_id, :scope=>[:user_id]

  def self.to_value(rating_str)
    rating_str = rating_str.sub(/\-/, '_')
    rating = APP_CONFIG['rating_values'][rating_str]
    rating.to_f
  end
end
