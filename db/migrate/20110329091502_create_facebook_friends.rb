class CreateFacebookFriends < ActiveRecord::Migration
  def self.up
    create_table :facebook_friends do |t|
      t.integer :user_id, :null => false
      t.decimal :facebook_uid, :null => false, :precision => 30
      t.string :name, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :facebook_friends
  end
end
