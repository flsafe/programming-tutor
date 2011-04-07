class RenameDisplayToFinished < ActiveRecord::Migration
  def self.up
    rename_column :exercise_sets, :display, :finished
  end

  def self.down
    rename_column :exercise_sets, :finished, :display
  end
end
