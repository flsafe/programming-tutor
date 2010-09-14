class ExerciseSet < ActiveRecord::Base
  acts_as_taggable
  acts_as_taggable_on :algorithms, :data_structures
  
  has_many :exercises, :dependent=>:nullify
  
  validates_presence_of :title, :description
  validates_uniqueness_of :title
end
