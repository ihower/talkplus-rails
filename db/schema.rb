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

ActiveRecord::Schema.define(:version => 20110813031651) do

  create_table "authorizations", :force => true do |t|
    t.string   "provider"
    t.string   "external_service_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authorizations", ["user_id"], :name => "index_authorizations_on_user_id"

  create_table "channel_users", :force => true do |t|
    t.integer  "channel_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "channel_users", ["channel_id"], :name => "index_channel_users_on_channel_id"
  add_index "channel_users", ["user_id"], :name => "index_channel_users_on_user_id"

  create_table "channels", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "channels", ["name"], :name => "index_channels_on_name"
  add_index "channels", ["owner_id"], :name => "index_channels_on_owner_id"

  create_table "messages", :force => true do |t|
    t.integer  "channel_id"
    t.text     "content"
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["channel_id"], :name => "index_messages_on_channel_id"
  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["uid"], :name => "index_users_on_uid"

end
