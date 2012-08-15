class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string "first_name", :limit => 25
      t.string "last_name", :limit => 50
      t.string "email", :default => "", :limit => 100, :null => false
      t.string "username", :limit => 25, :null => false
      t.string "hashed_password", :limit=> 40, :null => false
      t.string "salt", :limit=> 40, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
