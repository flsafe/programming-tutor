class Exercise < ActiveRecord::Base
  acts_as_taggable
  acts_as_taggable_on :algorithms, :data_structures

  has_many :figures
  has_many :hints  
  has_many :unit_tests
  has_many :completed_users, :through=>:grade_sheets, :source=>:user, :select=>'distinct users.*'
  has_many :grade_sheets, :after_add=>:update_stats

  belongs_to :exercise_set  
  
  after_update :save_associates
  
  validates_presence_of :title, :description, :problem, :tutorial, :minutes, :unit_tests
  validates_associated  :hints, :unit_tests, :figures, :exercise_set
  
  validates_uniqueness_of :title
  
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
  
  def can_be_created_by?(user)
    user.has_role? :admin
  end
  
  def can_be_edited_by?(user)
    user.has_role? :admin
  end
  
  def can_be_destroyed_by?(user)
    user.has_role? :admin
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

  def update_stats(gs)
    stats = ExerciseStatsTracker.new
    stats.update(gs)
  end
end
