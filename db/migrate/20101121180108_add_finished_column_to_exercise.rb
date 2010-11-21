class AddFinishedColumnToExercise < ActiveRecord::Migration
  def self.up
    add_column :exercises, :finished, :boolean
    Exercise.update_all("finished=0", "finished=NULL")
  end

  def self.down
    remove_column :exercises, :finished
  end
end
