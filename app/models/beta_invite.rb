class BetaInvite < ActiveRecord::Base
  validates_presence_of :email, :token
  validates_uniqueness_of :email, :token
  validates_format_of :email, :with=>/@/
  attr_protected :token

  def self.gen_token
    chartab =  %w{ 2 3 4 6 7 9 A B C D E F G H I J K L M N P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z}.to_a
    size = chartab.size
    (0..32).map { chartab[rand(size)] }.join
  end

  def self.new_invite(attr)
    i = BetaInvite.new attr
    i.token = BetaInvite.gen_token
    i
  end
end
