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

ActiveRecord::Schema.define(:version => 20140604113245) do

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
    t.float    "price",                :default => 0.0
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  add_index "business_categories_suppliers", ["business_category_id"], :name => "index_business_categories_suppliers_on_business_category_id"
  add_index "business_categories_suppliers", ["price"], :name => "index_business_categories_suppliers_on_price"
  add_index "business_categories_suppliers", ["supplier_id"], :name => "index_business_categories_suppliers_on_supplier_id"

  create_table "cities", :force => true do |t|
    t.string  "name"
    t.integer "province_id"
  end

  add_index "cities", ["name"], :name => "index_cities_on_name"
  add_index "cities", ["province_id"], :name => "index_cities_on_province_id"

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

  create_table "fashion_media_infos", :force => true do |t|
    t.integer  "city_id"
    t.string   "web_site"
    t.string   "web_site_introduction"
    t.string   "content_name"
    t.string   "position"
    t.string   "mobile"
    t.string   "email"
    t.string   "weixin"
    t.string   "address"
    t.float    "coverage"
    t.integer  "man"
    t.integer  "woman"
    t.text     "notes"
    t.integer  "updated_by"
    t.integer  "created_by"
    t.integer  "deleted",               :limit => 2, :default => 0
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  add_index "fashion_media_infos", ["city_id"], :name => "index_fashion_media_infos_on_city_id"
  add_index "fashion_media_infos", ["coverage"], :name => "index_fashion_media_infos_on_coverage"
  add_index "fashion_media_infos", ["created_by"], :name => "index_fashion_media_infos_on_created_by"
  add_index "fashion_media_infos", ["deleted"], :name => "index_fashion_media_infos_on_deleted"
  add_index "fashion_media_infos", ["updated_by"], :name => "index_fashion_media_infos_on_updated_by"
  add_index "fashion_media_infos", ["web_site"], :name => "index_fashion_media_infos_on_web_site"

  create_table "file_categories", :force => true do |t|
    t.integer  "project_id"
    t.integer  "parent_id",                  :default => 0
    t.string   "category_name"
    t.integer  "deleted",       :limit => 2, :default => 0
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "file_categories", ["created_by"], :name => "index_file_categories_on_created_by"
  add_index "file_categories", ["deleted"], :name => "index_file_categories_on_deleted"
  add_index "file_categories", ["parent_id"], :name => "index_file_categories_on_parent_id"
  add_index "file_categories", ["project_id"], :name => "index_file_categories_on_project_id"
  add_index "file_categories", ["updated_by"], :name => "index_file_categories_on_updated_by"

  create_table "grass_resources", :force => true do |t|
    t.string   "nickname"
    t.string   "media_url"
    t.integer  "fans_number"
    t.string   "category"
    t.string   "regional"
    t.integer  "type_id"
    t.text     "content_location"
    t.integer  "media_type_id"
    t.integer  "price"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "deleted",          :limit => 2
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "moderators", :force => true do |t|
    t.string   "media_name"
    t.string   "brand_name"
    t.string   "product_name"
    t.string   "name"
    t.string   "nickname"
    t.integer  "sex",                :limit => 2
    t.string   "position"
    t.integer  "age",                :limit => 3
    t.string   "mobile"
    t.string   "email"
    t.string   "weixin"
    t.string   "office_address"
    t.string   "id_number"
    t.datetime "birthday"
    t.string   "working_conditions"
    t.string   "active_record"
    t.string   "maintenance_record"
    t.string   "topic_of_concern"
    t.boolean  "married"
    t.string   "has_children"
    t.string   "has_car"
    t.string   "other_about"
    t.text     "notes"
    t.integer  "deleted",            :limit => 2, :default => 0
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  create_table "network_opinion_leader_bloggers", :force => true do |t|
    t.integer  "city_id"
    t.string   "nickname"
    t.string   "name"
    t.integer  "sex",                :limit => 2
    t.string   "media_name"
    t.string   "position"
    t.string   "mobile"
    t.string   "email"
    t.string   "id_number"
    t.datetime "birthday"
    t.string   "working_conditions"
    t.integer  "blog_traffic",       :limit => 8
    t.string   "blog_address"
    t.string   "web_url"
    t.string   "weixin"
    t.string   "active_record"
    t.string   "maintenance_record"
    t.string   "blog_style"
    t.string   "friendly_brand"
    t.string   "estranged_brand"
    t.text     "notes"
    t.integer  "updated_by"
    t.integer  "created_by"
    t.integer  "deleted",            :limit => 2, :default => 0
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "network_opinion_leader_bloggers", ["blog_style"], :name => "index_network_opinion_leader_bloggers_on_blog_style"
  add_index "network_opinion_leader_bloggers", ["city_id"], :name => "index_network_opinion_leader_bloggers_on_city_id"
  add_index "network_opinion_leader_bloggers", ["created_by"], :name => "index_network_opinion_leader_bloggers_on_created_by"
  add_index "network_opinion_leader_bloggers", ["deleted"], :name => "index_network_opinion_leader_bloggers_on_deleted"
  add_index "network_opinion_leader_bloggers", ["name"], :name => "index_network_opinion_leader_bloggers_on_name"
  add_index "network_opinion_leader_bloggers", ["updated_by"], :name => "index_network_opinion_leader_bloggers_on_updated_by"
  add_index "network_opinion_leader_bloggers", ["weixin"], :name => "index_network_opinion_leader_bloggers_on_weixin"

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

  create_table "project_files", :force => true do |t|
    t.integer  "project_id"
    t.integer  "file_category_id"
    t.string   "file_name"
    t.string   "save_name"
    t.integer  "deleted",          :limit => 2, :default => 0
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  add_index "project_files", ["created_by"], :name => "index_project_files_on_created_by"
  add_index "project_files", ["deleted"], :name => "index_project_files_on_deleted"
  add_index "project_files", ["file_category_id"], :name => "index_project_files_on_file_category_id"
  add_index "project_files", ["project_id"], :name => "index_project_files_on_project_id"
  add_index "project_files", ["updated_by"], :name => "index_project_files_on_updated_by"

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

  create_table "provinces", :force => true do |t|
    t.string  "name"
    t.integer "region_id"
    t.string  "remark"
  end

  add_index "provinces", ["name"], :name => "index_provinces_on_name"
  add_index "provinces", ["region_id"], :name => "index_provinces_on_region_id"
  add_index "provinces", ["remark"], :name => "index_provinces_on_remark"

  create_table "regions", :force => true do |t|
    t.string "name"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "specifications", :force => true do |t|
    t.integer "business_category_id"
    t.string  "name"
  end

  add_index "specifications", ["business_category_id"], :name => "index_specifications_on_business_category_id"

  create_table "specifications_suppliers", :force => true do |t|
    t.integer "specification_id"
    t.integer "supplier_id"
    t.float   "price"
  end

  create_table "supplier_evaluation_items", :force => true do |t|
    t.integer  "supplier_evaluation_id"
    t.integer  "specification_id"
    t.integer  "score"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "supplier_evaluations", :force => true do |t|
    t.integer  "supplier_id"
    t.text     "notes"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

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

  create_table "traveling_photography_media_infos", :force => true do |t|
    t.string   "web_site"
    t.string   "web_site_introduction"
    t.string   "content_name"
    t.string   "position"
    t.string   "mobile"
    t.string   "email"
    t.string   "address"
    t.float    "coverage"
    t.integer  "man"
    t.integer  "woman"
    t.text     "notes"
    t.integer  "updated_by"
    t.integer  "created_by"
    t.integer  "deleted",               :limit => 2, :default => 0
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  add_index "traveling_photography_media_infos", ["coverage"], :name => "index_traveling_photography_media_infos_on_coverage"
  add_index "traveling_photography_media_infos", ["created_by"], :name => "index_traveling_photography_media_infos_on_created_by"
  add_index "traveling_photography_media_infos", ["deleted"], :name => "index_traveling_photography_media_infos_on_deleted"
  add_index "traveling_photography_media_infos", ["updated_by"], :name => "index_traveling_photography_media_infos_on_updated_by"
  add_index "traveling_photography_media_infos", ["web_site"], :name => "index_traveling_photography_media_infos_on_web_site"

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

  create_table "web_site_media_reporters", :force => true do |t|
    t.integer  "region_id"
    t.integer  "province_id"
    t.integer  "city_id"
    t.integer  "format_id"
    t.string   "media_name"
    t.string   "level"
    t.string   "name"
    t.integer  "sex",                :limit => 2
    t.string   "department_name"
    t.string   "job_name"
    t.string   "telephone"
    t.string   "mobile"
    t.string   "email"
    t.string   "instant_messaging"
    t.string   "micro_blog"
    t.string   "micro_message"
    t.string   "office_address"
    t.string   "working_conditions"
    t.string   "birthday"
    t.string   "id_number"
    t.string   "origin_place"
    t.boolean  "married"
    t.string   "has_children"
    t.string   "has_car"
    t.string   "other_about"
    t.string   "active_record"
    t.string   "maintenance_record"
    t.text     "notes"
    t.integer  "is_substation",      :limit => 2, :default => 0
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "deleted",            :limit => 2, :default => 0
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "web_site_media_reporters", ["city_id"], :name => "index_web_site_media_reporters_on_city_id"
  add_index "web_site_media_reporters", ["created_by"], :name => "index_web_site_media_reporters_on_created_by"
  add_index "web_site_media_reporters", ["format_id"], :name => "index_web_site_media_reporters_on_format_id"
  add_index "web_site_media_reporters", ["is_substation"], :name => "index_web_site_media_reporters_on_is_substation"
  add_index "web_site_media_reporters", ["province_id"], :name => "index_web_site_media_reporters_on_province_id"
  add_index "web_site_media_reporters", ["region_id"], :name => "index_web_site_media_reporters_on_region_id"
  add_index "web_site_media_reporters", ["sex"], :name => "index_web_site_media_reporters_on_sex"
  add_index "web_site_media_reporters", ["updated_by"], :name => "index_web_site_media_reporters_on_updated_by"

end
