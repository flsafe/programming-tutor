class RemovePrimaryKeyFromExercisesUsers < ActiveRecord::Migration
  def self.up
    remove_column :exercises_users, :id
  end

  def self.down
    add_column :exercises_users, :id, :type=>:integer
  end
end
