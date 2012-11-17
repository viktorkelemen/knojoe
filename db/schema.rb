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

ActiveRecord::Schema.define(:version => 20121117080424) do

  create_table "chats", :force => true do |t|
    t.integer  "villager_id"
    t.integer  "guest_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "village_id"
    t.datetime "started_at"
    t.datetime "finished_at"
  end

  create_table "identities", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "image"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "identities", ["user_id"], :name => "index_identities_on_user_id"

  create_table "likes", :force => true do |t|
    t.integer  "message_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "likes", ["message_id"], :name => "index_likes_on_message_id"
  add_index "likes", ["user_id"], :name => "index_likes_on_user_id"

  create_table "messages", :force => true do |t|
    t.integer  "chat_id"
    t.integer  "author_id"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "messages", ["chat_id"], :name => "index_messages_on_chat_id"

  create_table "participations", :force => true do |t|
    t.integer  "village_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "participations", ["user_id"], :name => "index_participations_on_user_id"
  add_index "participations", ["village_id"], :name => "index_participations_on_village_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "email"
  end

  create_table "villages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "villager_counts", :default => 0
    t.integer  "villagers_count", :default => 0
  end

end
