class Exercise < ActiveRecord::Base
  acts_as_taggable
  acts_as_taggable_on :algorithms, :data_structures
  
  has_many :unit_tests
  has_many :completed_users, :through=>:grade_sheets, :source=>:user, :select=>'distinct users.*'
  has_many :grade_sheets, :after_add=>:update_stats
  has_many :hints
  belongs_to :exercise_set  
  
  validates_presence_of :title, :description, :problem, :tutorial, :minutes, :unit_tests
  
  def new_hint_attributes=(attributes)
    attributes.each do |att|
      hints.build att
    end
  end
  
  def  new_unit_test_attributes=(attributes)
    attributes.each do |att|
      if att[:unit_test_file] then
        unit_tests.build UnitTest.from_file_field(att[:unit_test_file])
      else
        unit_tests.build att
      end
    end
  end
  
  private
  
  def update_stats(gs)
    stats = ExerciseStatsTracker.new
    stats.update(gs)
  end
end
