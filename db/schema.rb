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

ActiveRecord::Schema.define(:version => 20131125043508) do

  create_table "business_categories", :force => true do |t|
    t.string   "name_cn",    :default => ""
    t.integer  "parent_id",  :default => 0
    t.integer  "is_show",    :default => 0
    t.integer  "created_by", :default => 0
    t.integer  "updated_by", :default => 0
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "business_categories", ["created_by"], :name => "index_business_categories_on_created_by"
  add_index "business_categories", ["is_show"], :name => "index_business_categories_on_is_show"
  add_index "business_categories", ["name_cn"], :name => "index_business_categories_on_name_cn"
  add_index "business_categories", ["parent_id"], :name => "index_business_categories_on_parent_id"
  add_index "business_categories", ["updated_by"], :name => "index_business_categories_on_updated_by"

  create_table "business_categories_suppliers", :force => true do |t|
    t.integer  "supplier_id",          :default => 0
    t.integer  "business_category_id", :default => 0
    t.string   "price",                :default => ""
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "business_categories_suppliers", ["business_category_id"], :name => "index_business_categories_suppliers_on_business_category_id"
  add_index "business_categories_suppliers", ["price"], :name => "index_business_categories_suppliers_on_price"
  add_index "business_categories_suppliers", ["supplier_id"], :name => "index_business_categories_suppliers_on_supplier_id"

  create_table "suppliers", :force => true do |t|
    t.string   "name",         :default => ""
    t.string   "contact_name", :default => ""
    t.string   "contact_way",  :default => ""
    t.integer  "created_by",   :default => 0
    t.integer  "updated_by",   :default => 0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "suppliers", ["contact_name"], :name => "index_suppliers_on_contact_name"
  add_index "suppliers", ["contact_way"], :name => "index_suppliers_on_contact_way"
  add_index "suppliers", ["name"], :name => "index_suppliers_on_name"

  create_table "users", :force => true do |t|
    t.string   "name",                   :default => "", :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
