class AddSytaxCheckResultTimestamps < ActiveRecord::Migration
  def self.up
    add_column :syntax_check_results, :created_at, :timestamp
    add_column :syntax_check_results, :modified_at, :timestamp
  end

  def self.down
    remove_column :syntax_check_results, :created_at
    remove_column :syntax_check_results, :modified_at
  end
end
