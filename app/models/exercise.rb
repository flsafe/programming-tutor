class Exercise < ActiveRecord::Base
  acts_as_taggable
  acts_as_taggable_on :algorithms, :datastructures
  
  has_one :unit_test
  has_many :completed_users, :through=>:grade_sheets, :source=>:user, :select=>'distinct users.*'
  has_many :grade_sheets, :after_add=>:update_stats
  belongs_to :exercise_set  

  attr_accessor :hints
  serialize :hints
  
  validates_presence_of :title, :description, :problem, :tutorial, :minutes, :unit_test
  
  def <<(hint_text)
    hints << hint_text
  end
  
  private
  
  def update_stats(gs)
    stats = ExerciseStatsTracker.new
    stats.update(gs)
  end
end
