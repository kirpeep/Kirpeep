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

ActiveRecord::Schema.define(:version => 20130410195054) do

  create_table "actions", :force => true do |t|
    t.integer  "userId"
    t.string   "type"
    t.string   "action"
    t.datetime "date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "assets", :force => true do |t|
    t.integer  "user_listing_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
  end

  create_table "chat_replies", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "message"
    t.integer  "init_user"
    t.integer  "targ_user"
    t.integer  "chat_id"
  end

  create_table "chats", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "init_user"
    t.integer  "targ_user"
    t.string   "message"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "exchange_items", :force => true do |t|
    t.string   "exchange_id"
    t.string   "user_listing_id"
    t.string   "targ_user_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "init_user_id"
    t.integer  "kirpoints_amounts"
  end

  create_table "exchange_message_links", :force => true do |t|
    t.string   "exchange_id"
    t.string   "message_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "exchanges", :force => true do |t|
    t.string  "type"
    t.string  "typeWhenTerm"
    t.string  "initUser"
    t.string  "targUser"
    t.string  "init_list_id"
    t.string  "targ_list_id"
    t.boolean "initAcpt"
    t.boolean "targAcpt"
    t.boolean "initComp"
    t.boolean "targComp"
    t.boolean "initCode"
    t.boolean "targCode"
    t.integer "init_rating_time"
    t.integer "init_rating_cost"
    t.integer "init_rating_ease"
    t.integer "init_rating_overall"
    t.integer "targ_rating_time"
    t.integer "targ_rating_cost"
    t.integer "targ_rating_ease"
    t.integer "targ_rating_overall"
    t.text    "init_comments"
    t.text    "targ_comments"
    t.string  "type_when_term"
    t.string  "initConfCode"
    t.string  "targConfCode"
    t.boolean "is_deleted",          :default => false, :null => false
  end

  create_table "messages", :force => true do |t|
    t.string   "initUser"
    t.string   "targUser"
    t.text     "text"
    t.boolean  "targUnread"
    t.boolean  "initUnread"
    t.string   "responseToMsgID"
    t.integer  "exchange_id"
    t.integer  "message_id"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "subject"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.boolean  "targ_is_deleted",    :default => false, :null => false
    t.boolean  "init_is_deleted",    :default => false, :null => false
    t.integer  "next_message_id"
  end

  create_table "modified_exchanges", :force => true do |t|
    t.integer  "modificationID"
    t.integer  "exchangeID"
    t.datetime "timeModified"
    t.string   "itemIDModified"
    t.string   "modification"
    t.integer  "prevModification"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "profiles", :force => true do |t|
    t.string   "interests",          :default => "Click Here to Edit Your Interests"
    t.string   "quickPitch",         :default => "Click Here to Edit Your Headline"
    t.string   "about",              :default => "Click Here to Edit Your About Me"
    t.string   "education",          :default => "Click Here to Edit Your Education"
    t.string   "location",           :default => "Click Here to Edit Your Location"
    t.string   "languages",          :default => "Click Here to Edit Your Languages"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.integer  "user_id"
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.string   "gender",             :default => "Click Here to Edit Your Gender"
    t.string   "birthdate",          :default => "Click Here to Edit Your Birthday"
    t.string   "zipcode",            :default => "Click Here to Edit Your Zipcode"
    t.string   "phone_number"
    t.boolean  "phone_verified"
    t.boolean  "number_verified"
    t.string   "group"
    t.string   "sector"
  end

  create_table "reviews", :force => true do |t|
    t.string   "reviewID"
    t.string   "profileID"
    t.text     "review"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "reviewerID"
    t.integer  "exchange_id"
  end

  create_table "time_stamps", :force => true do |t|
    t.integer  "exchangeID"
    t.datetime "timeInitiated"
    t.datetime "timeTerminated"
    t.datetime "timeAccepted"
    t.datetime "timeModified"
    t.datetime "timeCompleted"
    t.datetime "timeReviewed"
    t.datetime "timeRated"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "transactions", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "amount",     :precision => 10, :scale => 0
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "type"
  end

  create_table "user_listings", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "user_id"
    t.string   "type"
    t.text     "description"
    t.string   "title"
    t.integer  "quantity"
    t.string   "quantityUnit"
    t.datetime "availableUntil"
    t.integer  "inventoryCount"
    t.string   "imgURL"
    t.datetime "neededBy"
    t.string   "listingType"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
    t.boolean  "delta",                                               :default => true,  :null => false
    t.boolean  "is_modified_exchange",                                :default => false, :null => false
    t.boolean  "is_deleted",                                          :default => false, :null => false
    t.decimal  "kirpoints",            :precision => 10, :scale => 0
    t.string   "category"
    t.boolean  "shippable"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
    t.string   "street_address"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "remember_token"
    t.string   "salt"
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
    t.boolean  "Active"
    t.string   "token"
    t.decimal  "kirpoints",           :precision => 10, :scale => 0
    t.decimal  "kirpoints_committed", :precision => 10, :scale => 0
    t.boolean  "delta",                                              :default => true,  :null => false
    t.boolean  "is_deleted",                                         :default => false
    t.string   "uid"
    t.string   "provider"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "chat_status"
  end

end
