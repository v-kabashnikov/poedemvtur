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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160304141804) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blog_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blogs", force: :cascade do |t|
    t.string   "title"
    t.string   "preview_file_name"
    t.string   "preview_content_type"
    t.integer  "preview_file_size"
    t.datetime "preview_updated_at"
    t.text     "content"
    t.boolean  "display"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.string   "alias"
    t.string   "flag_file_name"
    t.string   "flag_content_type"
    t.integer  "flag_file_size"
    t.datetime "flag_updated_at"
    t.string   "header_img_file_name"
    t.string   "header_img_content_type"
    t.integer  "header_img_file_size"
    t.datetime "header_img_updated_at"
    t.boolean  "display"
    t.integer  "country_category_id"
    t.integer  "sletat_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "countries", ["country_category_id"], name: "index_countries_on_country_category_id", using: :btree

  create_table "country_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "depart_cities", force: :cascade do |t|
    t.string   "name"
    t.string   "alias"
    t.boolean  "display"
    t.integer  "sletat_id"
    t.integer  "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "depart_cities", ["country_id"], name: "index_depart_cities_on_country_id", using: :btree

  create_table "facilities", force: :cascade do |t|
    t.string   "name"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.integer  "facility_group_id"
    t.string   "hit"
    t.integer  "sletat_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "facilities", ["facility_group_id"], name: "index_facilities_on_facility_group_id", using: :btree

  create_table "facilities_hotels", id: false, force: :cascade do |t|
    t.integer "facility_id"
    t.integer "hotel_id"
  end

  add_index "facilities_hotels", ["facility_id", "hotel_id"], name: "index_facilities_hotels_on_facility_id_and_hotel_id", unique: true, using: :btree
  add_index "facilities_hotels", ["facility_id"], name: "index_facilities_hotels_on_facility_id", using: :btree
  add_index "facilities_hotels", ["hotel_id", "facility_id"], name: "index_facilities_hotels_on_hotel_id_and_facility_id", unique: true, using: :btree
  add_index "facilities_hotels", ["hotel_id"], name: "index_facilities_hotels_on_hotel_id", using: :btree

  create_table "facility_groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "sletat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hotel_options", force: :cascade do |t|
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.string   "name"
    t.string   "hit"
    t.integer  "sletat_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "hotels", force: :cascade do |t|
    t.string   "name"
    t.integer  "resort_id"
    t.string   "old_cyrillic_name"
    t.string   "old_latin_name"
    t.string   "subtitle"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "sletat_photo_url"
    t.float    "hotel_rate"
    t.integer  "rating_meal"
    t.integer  "rating_overall"
    t.integer  "rating_place"
    t.integer  "rating_service"
    t.string   "sletat_description"
    t.text     "description"
    t.string   "video"
    t.float    "city_center_distance"
    t.string   "beach_line"
    t.string   "district"
    t.float    "latitude"
    t.float    "longitude"
    t.float    "airport_distance"
    t.integer  "min_price"
    t.integer  "star_id"
    t.integer  "sletat_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "sletat_image_urls",    default: [],              array: true
    t.integer  "building_date"
    t.integer  "distance_to_lifts"
    t.integer  "rooms_count"
    t.integer  "square"
  end

  add_index "hotels", ["resort_id"], name: "index_hotels_on_resort_id", using: :btree
  add_index "hotels", ["star_id"], name: "index_hotels_on_star_id", using: :btree

  create_table "load_statuses", force: :cascade do |t|
    t.integer  "request_id"
    t.integer  "status"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "depart_city_id"
    t.integer  "country_id"
    t.date     "depart_from"
    t.integer  "adults"
    t.integer  "kids"
    t.string   "nights"
  end

  add_index "load_statuses", ["country_id"], name: "index_load_statuses_on_country_id", using: :btree
  add_index "load_statuses", ["depart_city_id"], name: "index_load_statuses_on_depart_city_id", using: :btree

  create_table "meals", force: :cascade do |t|
    t.string   "name"
    t.string   "alias"
    t.text     "description"
    t.integer  "sletat_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "resorts", force: :cascade do |t|
    t.string   "name"
    t.string   "alias"
    t.boolean  "display"
    t.integer  "country_id"
    t.integer  "sletat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "resorts", ["country_id"], name: "index_resorts_on_country_id", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.string   "name"
    t.date     "date"
    t.text     "comment"
    t.integer  "people_number"
    t.float    "rate"
    t.integer  "hotel_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.boolean  "sletat"
  end

  add_index "reviews", ["hotel_id"], name: "index_reviews_on_hotel_id", using: :btree

  create_table "search_results", force: :cascade do |t|
    t.integer "hotel_id"
    t.integer "request_id"
    t.integer "min_price"
    t.string  "meal"
    t.string  "depart_date"
    t.integer "nights"
  end

  add_index "search_results", ["hotel_id"], name: "index_search_results_on_hotel_id", using: :btree

  create_table "stars", force: :cascade do |t|
    t.string   "name"
    t.string   "alias"
    t.integer  "sletat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tour_operators", force: :cascade do |t|
    t.string   "name"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "site"
    t.string   "address"
    t.string   "phone"
    t.text     "description"
    t.string   "header_img_file_name"
    t.string   "header_img_content_type"
    t.integer  "header_img_file_size"
    t.datetime "header_img_updated_at"
    t.integer  "sletat_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "tour_results", force: :cascade do |t|
    t.integer  "hotel_id"
    t.date     "depart_date"
    t.integer  "nights"
    t.string   "depart_city"
    t.string   "meal"
    t.string   "tour_operator"
    t.string   "room_type"
    t.integer  "request_id"
    t.integer  "price"
    t.integer  "adults_number"
    t.integer  "children_number"
    t.string   "sletat_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "tour_results", ["hotel_id"], name: "index_tour_results_on_hotel_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "countries", "country_categories"
  add_foreign_key "depart_cities", "countries"
  add_foreign_key "facilities", "facility_groups"
  add_foreign_key "hotels", "resorts"
  add_foreign_key "hotels", "stars"
  add_foreign_key "load_statuses", "countries"
  add_foreign_key "load_statuses", "depart_cities"
  add_foreign_key "resorts", "countries"
  add_foreign_key "reviews", "hotels"
  add_foreign_key "search_results", "hotels"
  add_foreign_key "tour_results", "hotels"
end
