class BetaInvite < ActiveRecord::Base
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, :with=>/@/
  attr_protected :token
end
