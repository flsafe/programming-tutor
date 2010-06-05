class Exercise < ActiveRecord::Base  
  acts_as_taggable
  acts_as_taggable_on :algorithms, :data_structures

  has_many :figures
  has_many :hints  
  has_many :templates
  has_many :unit_tests
  has_many :completed_users, :through=>:grade_sheets, :source=>:user, :select=>'distinct users.*'
  has_many :grade_sheets, :after_add=>:update_stats

  belongs_to :exercise_set  
  
  after_update :save_associates
  
  validates_presence_of :title, :description, :problem, :tutorial, :minutes, :unit_tests
  validates_associated  :hints, :unit_tests, :figures, :exercise_set
  
  validates_uniqueness_of :title
    
  def self.recommend(user_id, how_many)
    exercises = Exercise.find :all
    how_many  = clamp(how_many, 0, exercises.size)

    indices  = random_indices(how_many, exercises.size)
    
    result = []
    indices.each {|i| result << exercises[i]}
    result
  end
  
  def new_template_attributes=(attributes)
    new_attributes_for(:templates, attributes)
  end
  
  def new_hint_attributes=(attributes)
    new_attributes_for(:hints, attributes)
  end
  
  def new_unit_test_attributes=(unit_test_attributes)
    new_attributes_for(:unit_tests, unit_test_attributes)
  end
  
  def new_figure_attributes=(figure_attributes)
    new_attributes_for(:figures, figure_attributes)
  end

  def new_exercise_set_attributes=(new_exercise_set_attributes)
    #A new exercise set hash is not always returned from the client, sometimes one is chosen from the select dropdown.
    self.exercise_set = build_exercise_set new_exercise_set_attributes unless new_exercise_set_attributes['title'].blank?
  end
  
  def existing_hint_attributes=(hint_attributes)
   existing_attributes_for(:hints, hint_attributes)
  end
  
  def existing_unit_test_attributes=(unit_test_attributes)
    existing_attributes_for(:unit_tests, unit_test_attributes)
  end
  
  protected
    
  def new_attributes_for(association, attributes)
    associates = self.send(association)
    attributes.each do |atts|
      associates.build atts
    end
  end
  
  def existing_attributes_for(association, associated_attributes)
    associates = self.send(association)
    associates.reject(&:new_record?).each do |associate|
      attributes = associated_attributes[associate.id.to_s]
      if attributes
        associate.attributes = attributes
      else
        associates.delete(associate)
      end
    end
  end
  
  def save_associates
    hints.each {|h| h.save(false)}
    unit_tests.each {|u| u.save(false)}
    exercise_set.save(false)
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

  def update_stats(gs)
    stats = ExerciseStatsTracker.new
    stats.update(gs)
  end
end
