class Gradeable < ActiveRecord::Base
  has_many :grade_sheets
  has_many :completed_users, :through=>:grade_sheets, :source=>:user
  
  validates_presence_of :title, :description
end