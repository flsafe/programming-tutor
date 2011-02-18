class AddRedeemedColumn < ActiveRecord::Migration
  def self.up
    add_column :beta_invites, :redeemed, :boolean
  end

  def self.down
    remove_column :beta_invites, :redeemed
  end
end
