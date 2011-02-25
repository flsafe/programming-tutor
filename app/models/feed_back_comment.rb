class FeedBackComment < ActiveRecord::Base
  validates_presence_of :email, :comment
end
