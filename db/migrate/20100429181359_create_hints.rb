class CreateHints < ActiveRecord::Migration
  def self.up
    create_table :hints, :force=>true do |t|
      t.integer :exercise_id
      t.text :text
    end
  end

  def self.down
    drop_table :hints
  end
end
