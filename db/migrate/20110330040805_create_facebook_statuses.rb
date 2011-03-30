class CreateFacebookStatuses < ActiveRecord::Migration
  def self.up
    create_table :facebook_statuses do |t|
      t.integer :user_id, :null => false
      
      t.string :facebook_status_id, :null => false
      t.string :name
      t.string :link
      t.string :caption
      t.text :description
      t.string :source
      t.string :status_type
      
      t.boolean :deteled, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :facebook_statuses
  end
end
