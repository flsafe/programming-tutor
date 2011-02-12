require 'net/http'

class Rating < ActiveRecord::Base
  validates_presence_of :user_id, :exercise_id, :rating
  validates_uniqueness_of :exercise_id, :scope=>[:user_id]

  after_save :push_rating

  def self.to_value(rating_str)
    rating_str = rating_str.sub(/\-/, '_')
    rating = APP_CONFIG['rating_values'][rating_str]
    rating.to_f
  end

  def self.has_rated?(user, exercise)
    Rating.find_by_user_id_and_exercise_id(user.id, exercise.id) != nil 
  end

  def push_rating
    Thread.new(user_id, exercise_id, rating) do |user_id, exercise_id, rating|
      uri = APP_CONFIG['recomendation_server_uri'][Rails.env]
      begin 
        Net::HTTP.post_form(URI.parse(uri),
                            "user_id"=>user_id, 
                            "exercise_id"=>exercise_id,
                            "rating"=>rating)
      rescue Exception => e
        Rails.logger.error "No connection to recomendation server"
      end
    end
  end
end
