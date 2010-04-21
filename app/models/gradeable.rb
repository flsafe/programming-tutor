class Gradeable < ActiveRecord::Base
  has_many :grade_sheets, :after_add => :track_stats
  has_many :completed_users, :through=>:grade_sheets, :source=>:user, :select=>'distinct users.*'
  
  validates_presence_of :title, :description
  
  def track_stats(grade_sheet);end
end