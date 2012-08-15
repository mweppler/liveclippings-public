class AddApiKeyToUserModel < ActiveRecord::Migration
  def change
    add_column :users, :api_token, :string, :limit => 40
    add_column :users, :api_token_created_at, :datetime
  end
end
