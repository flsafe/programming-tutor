class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :force=>true do |t|
      t.string :username
      t.string :email
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.integer :roles_mask, :default=>0
      
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
