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

ActiveRecord::Schema.define(:version => 20131217061701) do

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

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.string   "logo"
    t.integer  "created_by", :default => 0
    t.integer  "updated_by", :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "clients", ["created_by"], :name => "index_clients_on_created_by"
  add_index "clients", ["updated_by"], :name => "index_clients_on_updated_by"

  create_table "clients_users", :force => true do |t|
    t.integer  "client_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "clients_users", ["client_id"], :name => "index_clients_users_on_client_id"
  add_index "clients_users", ["user_id"], :name => "index_clients_users_on_user_id"

  create_table "department_permissions", :force => true do |t|
    t.integer  "department_id"
    t.integer  "permission_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "department_permissions", ["department_id"], :name => "index_department_permissions_on_department_id"
  add_index "department_permissions", ["permission_id"], :name => "index_department_permissions_on_permission_id"

  create_table "department_users", :force => true do |t|
    t.integer  "department_id"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "department_users", ["department_id"], :name => "index_department_users_on_department_id"
  add_index "department_users", ["user_id"], :name => "index_department_users_on_user_id"

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.integer  "space_id"
    t.integer  "city_id"
    t.integer  "province_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "departments", ["city_id"], :name => "index_departments_on_city_id"
  add_index "departments", ["province_id"], :name => "index_departments_on_province_id"
  add_index "departments", ["space_id"], :name => "index_departments_on_space_id"

  create_table "orders", :force => true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.integer  "business_category_id"
    t.integer  "supplier_id"
    t.integer  "is_finished",          :limit => 2,                               :default => 0
    t.datetime "finished_at"
    t.decimal  "price",                             :precision => 8, :scale => 2, :default => 0.0
    t.integer  "created_by"
    t.integer  "updated_by"
    t.text     "notes"
    t.datetime "created_at",                                                                       :null => false
    t.datetime "updated_at",                                                                       :null => false
  end

  add_index "orders", ["business_category_id"], :name => "index_orders_on_business_category_id"
  add_index "orders", ["created_by"], :name => "index_orders_on_created_by"
  add_index "orders", ["finished_at"], :name => "index_orders_on_finished_at"
  add_index "orders", ["is_finished"], :name => "index_orders_on_is_finished"
  add_index "orders", ["price"], :name => "index_orders_on_price"
  add_index "orders", ["project_id"], :name => "index_orders_on_project_id"
  add_index "orders", ["supplier_id"], :name => "index_orders_on_supplier_id"
  add_index "orders", ["updated_by"], :name => "index_orders_on_updated_by"

  create_table "permissions", :force => true do |t|
    t.string   "action"
    t.string   "subject_class"
    t.integer  "subject_id"
    t.string   "notes"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.integer  "client_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer  "budget"
    t.integer  "is_started",           :limit => 2, :default => 0
    t.datetime "is_started_at"
    t.integer  "business_category_id"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  add_index "projects", ["business_category_id"], :name => "index_projects_on_business_category_id"
  add_index "projects", ["client_id"], :name => "index_projects_on_client_id"
  add_index "projects", ["created_by"], :name => "index_projects_on_created_by"
  add_index "projects", ["updated_by"], :name => "index_projects_on_updated_by"

  create_table "projects_users", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "projects_users", ["project_id"], :name => "index_projects_users_on_project_id"
  add_index "projects_users", ["user_id"], :name => "index_projects_users_on_user_id"

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

  create_table "user_permissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "permission_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "user_permissions", ["permission_id"], :name => "index_user_permissions_on_permission_id"
  add_index "user_permissions", ["user_id"], :name => "index_user_permissions_on_user_id"

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
    t.integer  "department_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
