class RemoveModelNameFromStatistics < ActiveRecord::Migration
  def self.up
    remove_column :statistics, :model_name
  end

  def self.down
    add_column :statistics, :model_name, :string
  end
end
