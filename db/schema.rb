# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120610012244) do

  create_table "admin_users", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clippings", :force => true do |t|
    t.integer  "user_id",                                      :null => false
    t.string   "url"
    t.string   "title"
    t.string   "summary"
    t.string   "content_type", :limit => 4
    t.boolean  "read",                      :default => false
    t.boolean  "favorite",                  :default => false
    t.boolean  "archive",                   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "public",                    :default => false
    t.boolean  "delta",                     :default => true,  :null => false
  end

  add_index "clippings", ["title"], :name => "index_clippings_on_title"

  create_table "followings", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "follow_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stored_clippings", :force => true do |t|
    t.integer  "clipping_id", :null => false
    t.text     "content",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name",             :limit => 25
    t.string   "last_name",              :limit => 50
    t.string   "email",                  :limit => 100, :default => "", :null => false
    t.string   "username",               :limit => 25,                  :null => false
    t.string   "hashed_password",        :limit => 40,                  :null => false
    t.string   "salt",                   :limit => 40,                  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_hash"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "api_token",              :limit => 40
    t.datetime "api_token_created_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"
  add_index "users", ["username"], :name => "index_users_on_username"

end
