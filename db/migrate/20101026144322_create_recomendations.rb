class CreateRecomendations < ActiveRecord::Migration
  def self.up
    create_table :recomendations, :force=>true do |t|
      t.integer :user_id
      t.text :exercise_recomendation_list
    end
  end

  def self.down
    drop_table :recomendations
  end
end
