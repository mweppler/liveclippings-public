class AddPublicToClippings < ActiveRecord::Migration
  def self.up
    add_column :clippings, :public, :boolean, :default => false
  end

  def self.down
    remove_column :clippings, :public
  end
end