class CreateTwitterFollowers < ActiveRecord::Migration
  def self.up
    create_table :twitter_followers do |t|
      t.integer :user_id, :null => false
      
      t.decimal :twitter_id, :null => false, :precision => 30
      t.string :name
      t.string :screen_name      

      t.timestamps
    end
  end

  def self.down
    drop_table :twitter_followers
  end
end
