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

ActiveRecord::Schema.define(:version => 20120605195920) do

  create_table "accounts", :force => true do |t|
    t.string   "email",                :limit => 150,                          :null => false
    t.string   "role",                 :limit => 50,  :default => "presenter", :null => false
    t.string   "encrypted_password"
    t.string   "password_salt"
    t.string   "authentication_token"
    t.datetime "confirmed_at"
    t.datetime "reset_at"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
  end

  add_index "accounts", ["authentication_token"], :name => "index_accounts_on_authentication_token"
  add_index "accounts", ["email"], :name => "index_accounts_on_email"

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "review_id"
    t.integer  "presenter_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "comments", ["presenter_id"], :name => "index_comments_on_presenter_id"
  add_index "comments", ["review_id"], :name => "index_comments_on_review_id"

  create_table "presenters", :force => true do |t|
    t.string   "name",       :limit => 100
    t.text     "bio"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "account_id"
  end

  add_index "presenters", ["account_id"], :name => "index_presenters_on_account_id"

  create_table "reviews", :force => true do |t|
    t.text     "things_i_like"
    t.integer  "score"
    t.integer  "session_id"
    t.integer  "presenter_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.text     "things_to_improve"
  end

  add_index "reviews", ["presenter_id"], :name => "index_reviews_on_presenter_id"
  add_index "reviews", ["session_id"], :name => "index_reviews_on_session_id"

  create_table "sessions", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "sub_title"
    t.string   "short_description"
    t.string   "session_type"
    t.string   "topic"
    t.string   "duration"
    t.string   "intended_audience"
    t.string   "experience_level"
    t.string   "max_participants"
    t.string   "laptops_required"
    t.string   "other_limitations"
    t.string   "room_setup"
    t.string   "materials_needed"
    t.string   "session_goal"
    t.string   "outline_or_timetable"
    t.integer  "first_presenter_id"
    t.integer  "second_presenter_id"
  end

  add_index "sessions", ["first_presenter_id"], :name => "index_sessions_on_first_presenter_id"
  add_index "sessions", ["second_presenter_id"], :name => "index_sessions_on_second_presenter_id"

end
