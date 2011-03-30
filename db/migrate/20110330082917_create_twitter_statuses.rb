class CreateTwitterStatuses < ActiveRecord::Migration
  def self.up
    create_table :twitter_statuses do |t|
      t.integer :user_id, :null => false
      t.decimal :twitter_status_id, :null => false, :precision => 30
      t.string :text

      t.timestamps
    end
  end

  def self.down
    drop_table :twitter_statuses
  end
end
