class RenameLocalIdColumn < ActiveRecord::Migration
  def self.up
    rename_column :exercises, :local_id, :push_id
    rename_column :exercise_sets, :local_id, :push_id
  end

  def self.down
    rename_column :exercises, :push_id, :local_id
    rename_column :exercise_sets, :push_id, :local_id
  end
end
