class ExerciseSet < ActiveRecord::Base
  has_many :exercises
  has_many :set_grade_sheets, :after_add=>:track_stats
  has_many :completed_users, :source=>:user, :through=>:set_grade_sheets
  
  validates_presence_of :title, :description
  
  def self.recommend(user_id, how_many)
    sets     = ExerciseSet.find :all
    how_many = clamp(how_many, 0, sets.size)

    indices  = random_indices(how_many, sets.size)
    
    result = []
    indices.each {|i| result << sets[i]}
    result
  end
  
   def track_stats(grade_sheet)
    update_exercise_average_grade(grade_sheet)
    self.save
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
  
  def self.clamp(v, min, max)
    [[v, max].min, min].max
  end
  
  def update_exercise_average_grade(grade_sheet)
    self.average_grade = new_average(average_grade, grade_sheet.grade, completed_users.count)
  end
  
  def new_average(old_average, new_grade, n_new_users)
    return if n_new_users == 0
    old_average ||= 0
    old_average + (new_grade - old_average) / n_new_users
  end
end
