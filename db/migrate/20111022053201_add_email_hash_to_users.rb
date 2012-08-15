class AddEmailHashToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :user_hash, :string, :limit => 255
  end

  def self.down
    remove_column :users, :user_hash
  end
end
