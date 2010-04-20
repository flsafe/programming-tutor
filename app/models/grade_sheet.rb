class GradeSheet < ActiveRecord::Base
  belongs_to :user
  belongs_to :gradeable
  #belongs_to :resource, :polymorphic=>true
  
  validates_presence_of :user, :grade, :gradeable
end