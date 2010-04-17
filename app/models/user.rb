class User < ActiveRecord::Base
  acts_as_authentic
  
  has_and_belongs_to_many :exercises
  
  def completed?(exercise_set)
    false
  end
end
