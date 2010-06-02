class ExerciseSet < ActiveRecord::Base
  acts_as_taggable
  acts_as_taggable_on :algorithms, :data_structures
  
  has_many :exercises
  has_many :set_grade_sheets, :after_add=>:update_stats
  has_many :completed_users, :source=>:user, :through=>:set_grade_sheets
  
  validates_presence_of :title, :description
  validates_uniqueness_of :title
  
  protected 
  
   def update_stats(gs)
    stats = ExerciseSetStatsTracker.new
    stats.update(gs)
  end
end
