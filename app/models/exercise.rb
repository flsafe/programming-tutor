class Exercise < ActiveRecord::Base
  has_many :completed_users, :through=>:grade_sheets, :source=>:user, :select=>'distinct users.*'
  has_many :grade_sheets, :after_add=>:update_stats
  belongs_to :exercise_set
  
  validates_presence_of :title, :description
  
  def update_stats(gs)
    stats = ExerciseStatsTracker.new
    stats.update(gs)
  end
end
