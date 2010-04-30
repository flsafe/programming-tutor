class Exercise < ActiveRecord::Base
  acts_as_taggable
  acts_as_taggable_on :algorithms, :data_structures
  
  has_many :unit_tests
  has_many :completed_users, :through=>:grade_sheets, :source=>:user, :select=>'distinct users.*'
  has_many :grade_sheets, :after_add=>:update_stats
  has_many :hints
  belongs_to :exercise_set  
  
  after_update :save_associates
  
  validates_presence_of :title, :description, :problem, :tutorial, :minutes, :unit_tests
  validates_associated  :hints, :unit_tests
  
  def new_hint_attributes=(attributes)
    attributes.each do |att|
      hints.build att
    end
  end
  
  def existing_hint_attributes=(hint_attributes)
    hints.reject(&:new_record?).each do |hint|
      attributes = hint_attributes[hint.id.to_s]
      if attributes
        hint.attributes = attributes
      else
        hints.delete(hint)
      end
    end
  end
  
  def  new_unit_test_attributes=(unit_test_attributes)
    unit_test_attributes.each do |attributes|
      if attributes[:unit_test_file] then
        unit_tests.build UnitTest.from_file_field(attributes[:unit_test_file])
      else
        unit_tests.build attributes
      end
    end
  end
  
  def existing_unit_test_attributes=(unit_test_attributes)
    unit_tests.reject(&:new_record?).each do |unit_test|
      attributes = unit_test_attributes[unit_test.id.to_s]
      if attributes
        unit_test.attributes = attributes
      else
        unit_tests.delete(unit_test)
      end
    end
  end
  
  def save_associates
    hints.each {|h| h.save(false)}
    unit_tests.each {|u| u.save(false)}
  end
  
  private
  
  def update_stats(gs)
    stats = ExerciseStatsTracker.new
    stats.update(gs)
  end
end
