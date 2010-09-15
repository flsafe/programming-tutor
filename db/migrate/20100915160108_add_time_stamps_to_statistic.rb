class AddTimeStampsToStatistic < ActiveRecord::Migration
  def self.up
    add_column :statistics, :created_at, :timestamp
  end

  def self.down
    remove_column :statistics, :created_at, :timestamp
  end
end
