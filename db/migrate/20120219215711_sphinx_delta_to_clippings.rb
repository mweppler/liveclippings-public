class SphinxDeltaToClippings < ActiveRecord::Migration
  def self.up
  	add_column :clippings, :delta, :boolean, :default => true, :null => false
  end

  def self.down
  	remove_column :clippings, :delta
  end
end
