class Hint < ActiveRecord::Base
  belongs_to :exercise
  validates_presence_of :text

  def text=(t)
    self[:text] = t.sub_start_end_code 
  end
end
