class Exercise < ActiveRecord::Base
  has_many :grade_sheets, :as=>:resource
  has_many :completed_users, :through=>:grade_sheets, :source=>:user
  belongs_to :exercise_set
  
  validates_presence_of :title, :description
end
