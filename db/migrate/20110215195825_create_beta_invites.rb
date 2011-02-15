class CreateBetaInvites < ActiveRecord::Migration
  def self.up
    create_table :beta_invites, :force=>true do |t|
      t.integer :id
      t.string :email
      t.string :token
    end
  end

  def self.down
    drop_table :beta_invites
  end
end
