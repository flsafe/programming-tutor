class Exercise < ActiveRecord::Base
  has_and_belongs_to_many :user
  belongs_to :exercise_set
end
