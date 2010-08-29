class DeleteSyntaxCheckResult < ActiveRecord::Migration
  def self.up
    drop_table :syntax_check_results
  end

  def self.down
     create_table :syntax_check_results, :force=>true do |t|
      t.integer :user_id
      t.integer :exercise_id
      t.text    :error_message
    end
  end
end
