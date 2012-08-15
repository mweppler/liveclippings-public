class CreateAdminUsers < ActiveRecord::Migration
  def self.up
    create_table :admin_users do |t|
      t.integer "user_id", :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :admin_users
  end
end
