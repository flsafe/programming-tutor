class GradeSheet < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource, :polymorphic=>true
  
  validates_presence_of :user, :resource, :grade
end