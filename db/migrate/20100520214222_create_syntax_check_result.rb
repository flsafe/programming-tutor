class SyntaxCheckResult < ActiveRecord::Migration
  def self.up
    create_table :syntax_check_results, :force=>true do |t|
      t.integer :user_id
      t.integer :exercise_id
      t.text    :error_message
    end
  end

  def self.down
    drop_table :syntax_check_results
  end
end
