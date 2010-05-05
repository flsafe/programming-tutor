class ExerciseSet < ActiveRecord::Base
  acts_as_taggable
  acts_as_taggable_on :algorithms, :data_structures
  
  has_many :exercises
  has_many :set_grade_sheets, :after_add=>:update_stats
  has_many :completed_users, :source=>:user, :through=>:set_grade_sheets
  
  validates_presence_of :title, :description
  validates_uniqueness_of :title
  
  def self.recommend(user_id, how_many)
    sets     = ExerciseSet.find :all
    how_many = clamp(how_many, 0, sets.size)

    indices  = random_indices(how_many, sets.size)
    
    result = []
    indices.each {|i| result << sets[i]}
    result
  end
  
  private 
  
   def update_stats(gs)
    stats = ExerciseSetStatsTracker.new
    stats.update(gs)
  end
  
  def self.random_indices(how_many, size_of_array)
    indices = []
    while indices.size != how_many
      index = rand(size_of_array)
      indices << index if not indices.include?(index)
    end
    indices
  end
  
  def self.clamp(v, min, max)
    [[v, max].min, min].max
  end
end
