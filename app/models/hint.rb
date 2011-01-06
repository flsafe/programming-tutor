class Hint < ActiveRecord::Base
  belongs_to :exercise
  validates_presence_of :text
end
