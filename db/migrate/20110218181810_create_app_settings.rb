class CreateAppSettings < ActiveRecord::Migration
  def self.up
    create_table :app_settings, :force=>true do |t|
      t.string :setting
      t.integer :int_value
      t.float :flt_value
      t.string :str_value

      t.time_stamps
    end
  end

  def self.down
    drop_table :app_settings
  end
end
