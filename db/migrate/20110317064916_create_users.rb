class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login, :null => true
      t.string :email, :null => true
      t.string :crypted_password, :null => true
      t.string :password_salt, :null => true
      t.string :persistence_token, :null => true
      t.string :perishable_token, :null => true
      
      t.integer :login_count, :default => 0
      t.integer :failed_login_count, :default => 0
      
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string :current_login_ip
      t.string :last_login_ip
      
      t.boolean :active, :default => false, :null => false
      t.boolean :social_login, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
