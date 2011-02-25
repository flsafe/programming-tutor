class CreateFeedBackComments < ActiveRecord::Migration
  def self.up
    create_table :feed_back_comments do |t|
      t.string :email
      t.string :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :feed_back_comments
  end
end
