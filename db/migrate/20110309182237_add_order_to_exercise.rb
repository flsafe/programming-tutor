class AddOrderToExercise < ActiveRecord::Migration
  def self.up
    add_column :exercises, :order, :integer
  end

  def self.down
    remove_column :exercises, :order
  end
end
