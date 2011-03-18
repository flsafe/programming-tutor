class MigrateForProgressPyramid < ActiveRecord::Migration
  def self.up
    # The new pyramid requires reseting the current plate.
    # Could be anoying but not fatal
    User.find(:all).each do |u|
      u.plate.replace([])
      u.save
    end
  end

  def self.down
  end
end
