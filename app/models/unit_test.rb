class UnitTest < ActiveRecord::Base
  belongs_to :exercise
  
  validates_presence_of :src_language, :src_code
end