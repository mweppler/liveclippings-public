class CreateStoredClippings < ActiveRecord::Migration
  def self.up
    create_table :stored_clippings do |t|
      t.integer "clipping_id", :null => false
      t.text "content", :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :stored_clippings
  end
end
