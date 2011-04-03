class AddLocalId < ActiveRecord::Migration
  def self.up
    add_column :exercise_sets, :local_id, :integer
    add_column :exercises, :local_id, :integer
  end

  def self.down
    remove_column :exercise_sets, :local_id
    remove_column :exercises, :local_id
  end
end
