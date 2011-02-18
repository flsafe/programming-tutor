class AddBetaInviteTimeStamps < ActiveRecord::Migration
  def self.up
    add_column :beta_invites, :created_at, :timestamp
    add_column :beta_invites, :updated_at, :timestamp
  end

  def self.down
    remove_column :beta_invites, :created_at, :timestamp
    remove_column :beta_invites, :updated_at, :timestamp
  end
end
