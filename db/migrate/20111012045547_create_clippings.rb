class CreateClippings < ActiveRecord::Migration
  def self.up
    create_table :clippings do |t|
      t.integer "user_id", :null => false
      t.string "url", :limit => 255
      t.string "title", :limit => 255
      t.string "summary", :limit => 255
      t.string "content_type", :limit => 4 # (html, text)
      t.boolean "read", :default => false
      t.boolean "favorite", :default => false
      t.boolean "archive", :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :clippings
  end
end
