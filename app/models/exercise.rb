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
  validates_associated  :hints, :unit_tests
  
  validates_uniqueness_of :title
  
  def new_hint_attributes=(attributes)
    new_attributes_for(:hints, attributes)
  end
  
  def existing_hint_attributes=(hint_attributes)
   existing_attributes_for(:hints, hint_attributes)
  end
  
  def  new_unit_test_attributes=(unit_test_attributes)
    new_attributes_for(:unit_tests, unit_test_attributes)
  end
  
  def existing_unit_test_attributes=(unit_test_attributes)
    existing_attributes_for(:unit_tests, unit_test_attributes)
  end
  
  private
  
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
  end

  def update_stats(gs)
    stats = ExerciseStatsTracker.new
    stats.update(gs)
  end
end
