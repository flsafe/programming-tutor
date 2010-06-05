class CreateTemplates < ActiveRecord::Migration
  def self.up
    create_table :templates, :force=>true do |t|
      t.integer :exercise_id
      t.text    :src_code
      t.string  :src_language
      
      t.timestamps
    end
  end

  def self.down
    drop_table :templates
  end
end
