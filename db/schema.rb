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

ActiveRecord::Schema.define(:version => 20101230141631) do

  create_table "fan_checks", :force => true do |t|
    t.string   "twitter_id",        :null => false
    t.string   "user_a",            :null => false
    t.string   "user_b",            :null => false
    t.boolean  "valid_a",           :null => false
    t.boolean  "valid_b",           :null => false
    t.string   "user_a_id"
    t.string   "user_b_id"
    t.boolean  "protected_a"
    t.boolean  "protected_b"
    t.boolean  "verified_a"
    t.boolean  "verified_b"
    t.string   "user_a_dp"
    t.string   "user_b_dp"
    t.boolean  "a_fan_of_b"
    t.boolean  "b_fan_of_a"
    t.boolean  "a_b_friends"
    t.integer  "state"
    t.datetime "checked_at",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "followers_count_a"
    t.integer  "followers_count_b"
  end

  create_table "users", :force => true do |t|
    t.string   "twitter_id",                              :null => false
    t.string   "oauth_token",                             :null => false
    t.string   "oauth_token_secret",                      :null => false
    t.string   "mode",               :default => "guest", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
