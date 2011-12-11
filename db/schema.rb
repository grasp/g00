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

ActiveRecord::Schema.define(:version => 20101222082022) do

  create_table "cargo_categories", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.integer  "ancestry_depth", :default => 0
  end

  add_index "cargo_categories", ["ancestry"], :name => "index_cargo_categories_on_ancestry"

  create_table "cargos", :force => true do |t|
    t.string   "cargo_weight"
    t.string   "cargo_zuhuo"
    t.string   "cargo_bulk"
    t.string   "send_date"
    t.string   "comments"
    t.string   "status"
    t.string   "cate_name"
    t.string   "package_name"
    t.string   "big_category"
    t.string   "line"
    t.string   "fcity_name"
    t.string   "tcity_name"
    t.string   "fcity_code"
    t.string   "tcity_code"
    t.integer  "user_id"
    t.integer  "company_id"
    t.integer  "stock_cargo_id"
    t.integer  "user_contact_id"
    t.string   "zhuang_addr"
    t.string   "zhuang_time"
    t.string   "xie_addr"
    t.integer  "pingjia_id"
    t.integer  "cstatistic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.integer  "ancestry_depth", :default => 0
  end

  add_index "cities", ["ancestry"], :name => "index_cities_on_ancestry"

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.text     "about"
    t.integer  "self_che"
    t.integer  "signed_che"
    t.integer  "num_employ"
    t.string   "contact_name"
    t.string   "city_name"
    t.string   "city_code"
    t.string   "city_id"
    t.string   "address"
    t.string   "fix_phone"
    t.string   "mobile_phone"
    t.string   "email"
    t.string   "company_license_id"
    t.string   "user_name"
    t.integer  "user_id"
    t.integer  "ispersonal"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cstatistics", :force => true do |t|
    t.integer  "total_baojia"
    t.integer  "total_xunjia"
    t.integer  "total_match"
    t.integer  "total_click"
    t.integer  "user_id"
    t.integer  "cargo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inqueries", :force => true do |t|
    t.integer  "price"
    t.string   "comments"
    t.string   "status"
    t.integer  "cargo_id"
    t.integer  "truck_id"
    t.integer  "truck_company_id"
    t.integer  "truck_user_id"
    t.integer  "cargo_company_id"
    t.integer  "cargo_user_id"
    t.integer  "ismailed"
    t.integer  "isaccepted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "line_ads", :force => true do |t|
    t.string   "line"
    t.string   "fcity_name"
    t.string   "tcity_name"
    t.string   "company_name"
    t.string   "url"
    t.string   "one_word"
    t.string   "contact_phone"
    t.integer  "user_id"
    t.integer  "company_id"
    t.string   "lstatistic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lstatistics", :force => true do |t|
    t.string   "line"
    t.integer  "valid_cargo"
    t.integer  "valid_truck"
    t.integer  "total_cargo"
    t.integer  "total_truck"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "package_categories", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.integer  "ancestry_depth", :default => 0
  end

  add_index "package_categories", ["ancestry"], :name => "index_package_categories_on_ancestry"

  create_table "quotes", :force => true do |t|
    t.integer  "price"
    t.string   "comments"
    t.integer  "cargo_id"
    t.integer  "truck_id"
    t.integer  "truck_user_id"
    t.integer  "truck_company_id"
    t.integer  "cargo_user_id"
    t.integer  "cargo_company_id"
    t.string   "status"
    t.integer  "ismailed"
    t.integer  "isaccepted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scans", :force => true do |t|
    t.integer  "total_user"
    t.integer  "total_stock_truck"
    t.integer  "total_stock_cargo"
    t.integer  "idle_stock_truck"
    t.integer  "idle_stock_cargo"
    t.integer  "total_cargo"
    t.integer  "total_truck"
    t.integer  "expired_cargo"
    t.integer  "expired_truck"
    t.integer  "chenjiao_truck"
    t.integer  "chenjiao_cargo"
    t.integer  "total_line"
    t.integer  "total_company"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", :force => true do |t|
    t.string   "fcity_code"
    t.string   "fcity_name"
    t.string   "tcity_code"
    t.string   "tcity_name"
    t.string   "stype"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stock_cargos", :force => true do |t|
    t.string   "big_category"
    t.string   "cate_name"
    t.string   "cate_code"
    t.string   "package_name"
    t.string   "package_code"
    t.string   "cargo_property"
    t.string   "stock_status"
    t.string   "ku_weight"
    t.string   "ku_bulk"
    t.integer  "cangku_id"
    t.string   "sent_weight"
    t.string   "sent_bulk"
    t.integer  "user_id"
    t.integer  "company_id"
    t.integer  "scstatistic_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stock_trucks", :force => true do |t|
    t.string   "paizhao"
    t.string   "dun_wei"
    t.string   "che_length"
    t.string   "truck_usage"
    t.string   "truck_shape"
    t.string   "truck_gps"
    t.string   "truck_pinpai"
    t.string   "truck_xinghao"
    t.string   "truck_year"
    t.string   "driver_name"
    t.string   "driver_phone"
    t.integer  "company_id"
    t.string   "car_phone"
    t.integer  "user_id"
    t.string   "status"
    t.integer  "truck_license_id"
    t.integer  "truck_owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trucks", :force => true do |t|
    t.string   "paizhao"
    t.string   "dunwei"
    t.string   "length"
    t.string   "shape"
    t.string   "usage"
    t.string   "driver_name"
    t.string   "driver_phone"
    t.string   "car_phone"
    t.string   "send_date"
    t.string   "status"
    t.string   "comments"
    t.string   "huicheng"
    t.string   "line"
    t.string   "fcity_name"
    t.string   "tcity_name"
    t.string   "fcity_code"
    t.string   "tcity_code"
    t.integer  "company_id"
    t.integer  "user_id"
    t.integer  "stock_truck_id"
    t.integer  "user_contact_id"
    t.integer  "truck_pingjia_id"
    t.integer  "truck_status_id"
    t.integer  "tstatistic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tstatistics", :force => true do |t|
    t.integer  "total_baojia"
    t.integer  "total_xunjia"
    t.integer  "total_match"
    t.integer  "total_click"
    t.integer  "user_id"
    t.integer  "truck_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_contacts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "mphone"
    t.string   "quhao"
    t.string   "fixphone"
    t.string   "QQ"
    t.string   "website"
    t.string   "city_name"
    t.string   "city_code"
    t.string   "address"
    t.integer  "company_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "real_name"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "status"
    t.string   "activate"
    t.integer  "company_id"
    t.integer  "user_contact_id"
    t.integer  "ustatistic_id"
    t.integer  "preference"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ustatistics", :force => true do |t|
    t.integer  "total_stock_cargo"
    t.integer  "total_stock_truck"
    t.integer  "total_cargo"
    t.integer  "total_truck"
    t.integer  "total_line"
    t.integer  "total_driver"
    t.integer  "total_custermer"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
