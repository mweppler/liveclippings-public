class AddInitialIndexesToTables < ActiveRecord::Migration
  def self.up
    add_index :users, :last_name
    add_index :users, :email
    add_index :users, :username
    add_index :clippings, :title
  end

  def self.down
    remove_index :users, :last_name
    remove_index :users, :email
    remove_index :users, :username
    remove_index :clippings, :title
  end
end