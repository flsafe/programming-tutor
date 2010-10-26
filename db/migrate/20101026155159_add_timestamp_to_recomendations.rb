class AddTimestampToRecomendations < ActiveRecord::Migration
  def self.up
    add_column :recomendations, :created_at, :timestamp
    add_column :recomendations, :updated_at, :timestamp
  end

  def self.down
    remove_column :recomendations, :created_at
    remove_column :recomendations, :updated_at
  end
end
