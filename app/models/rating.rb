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

  def push_rating
    Thread.new(user_id, exercise_id, rating) do |user_id, exercise_id, rating|
      uri = APP_CONFIG['recomendation_server_uri'][Rails.env]
      begin 
        Net::HTTP.post_form(URI.parse(uri),
                            "user_id"=>user_id, 
                            "exercise_id"=>exercise_id,
                            "rating"=>rating)
      rescue Exception => e
        #nothing for now
        puts e.to_s
        puts "No rec server connection"
      end
    end
  end
end
