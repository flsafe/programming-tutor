class ExerciseSet < ActiveRecord::Base
  validates_presence_of :title, :description
  
  def self.recommend(user_id, how_many)
    sets = ExerciseSet.find :all
    how_many = [how_many, sets.size].min

    indices = random_indices(how_many, sets.size)
    
    result = []
    indices.each {|i| result << sets[i]}
    result
  end
  
  private 
  
  def self.random_indices(how_many, size_of_array)
    indices = []
    while indices.size != how_many
      index = rand(size_of_array)
      indices << index if not indices.include?(index)
    end
    indices
  end
end
