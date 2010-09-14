class DeleteStatisticsColumnsFromExercises < ActiveRecord::Migration
  def self.up
    remove_column :exercises, :average_grade
    remove_column :exercises, :average_seconds
  end

  def self.down
    add_column :exercises, :average_grade, :float
    add_coumn :exercises, :average_seconds, :integer
  end
end
