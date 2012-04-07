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

ActiveRecord::Schema.define(:version => 20120407035028) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "items", :force => true do |t|
    t.integer  "user_id"
    t.integer  "list_id"
    t.string   "name",       :limit => 80,  :null => false
    t.string   "nickname",   :limit => 30,  :null => false
    t.string   "avatar_url", :limit => 140
    t.text     "content"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "items", ["list_id"], :name => "index_items_on_list_id"
  add_index "items", ["user_id"], :name => "index_items_on_user_id"

  create_table "list_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "list_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "list_users", ["list_id"], :name => "index_list_users_on_list_id"
  add_index "list_users", ["user_id"], :name => "index_list_users_on_user_id"

  create_table "lists", :force => true do |t|
    t.integer  "user_id"
    t.string   "title",       :limit => 80,  :null => false
    t.string   "name",        :limit => 80,  :null => false
    t.string   "nickname",    :limit => 30,  :null => false
    t.string   "avatar_url",  :limit => 140
    t.integer  "category_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "lists", ["category_id"], :name => "index_lists_on_category_id"
  add_index "lists", ["user_id"], :name => "index_lists_on_user_id"

  create_table "photos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.string   "file_uri"
    t.string   "salt"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "photos", ["item_id"], :name => "index_photos_on_item_id"
  add_index "photos", ["user_id"], :name => "index_photos_on_user_id"

  create_table "songs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.string   "name"
    t.string   "player"
    t.string   "album_name"
    t.date     "album_year"
    t.string   "album_cover"
    t.string   "salt"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "songs", ["item_id"], :name => "index_songs_on_item_id"
  add_index "songs", ["user_id"], :name => "index_songs_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name",                   :limit => 80
    t.string   "nickname",               :limit => 30
    t.string   "bio",                    :limit => 640
    t.string   "avatar_url",             :limit => 140
    t.string   "html_url",               :limit => 100
    t.string   "salt"
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",                    :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "voices", :force => true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.string   "file_uri"
    t.string   "salt"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "voices", ["item_id"], :name => "index_voices_on_item_id"
  add_index "voices", ["user_id"], :name => "index_voices_on_user_id"

end
