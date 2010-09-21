class AddAnonymousColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :anonymous, :boolean
  end

  def self.down
    remove_column :users, :anonymous
  end
end
