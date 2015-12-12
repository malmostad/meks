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

ActiveRecord::Schema.define(version: 20151209110051) do

  create_table "assignments", force: :cascade do |t|
    t.integer  "home_id",                limit: 4
    t.integer  "refugee_id",             limit: 4
    t.date     "moved_in_at"
    t.date     "moved_out_at"
    t.integer  "moved_out_reason_id", limit: 4
    t.text     "comment",                limit: 65535
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "assignments", ["moved_out_reason_id"], name: "index_assignments_on_moved_out_reason_id", using: :btree
  add_index "assignments", ["home_id"], name: "index_assignments_on_home_id", using: :btree
  add_index "assignments", ["refugee_id"], name: "index_assignments_on_refugee_id", using: :btree

  create_table "countries", force: :cascade do |t|
    t.string   "name",       limit: 191
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "countries", ["name"], name: "index_countries_on_name", unique: true, using: :btree

  create_table "countries_homes", id: false, force: :cascade do |t|
    t.integer "country_id", limit: 4
    t.integer "home_id",    limit: 4
  end

  add_index "countries_homes", ["country_id"], name: "index_countries_homes_on_country_id", using: :btree
  add_index "countries_homes", ["home_id"], name: "index_countries_homes_on_home_id", using: :btree

  create_table "countries_refugees", id: false, force: :cascade do |t|
    t.integer  "country_id", limit: 4
    t.integer  "refugee_id", limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "countries_refugees", ["country_id"], name: "index_countries_refugees_on_country_id", using: :btree
  add_index "countries_refugees", ["refugee_id"], name: "index_countries_refugees_on_refugee_id", using: :btree

  create_table "moved_out_reasons", force: :cascade do |t|
    t.string   "name",       limit: 191
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "dossier_numbers", force: :cascade do |t|
    t.string   "name",       limit: 191
    t.integer  "refugee_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "dossier_numbers", ["refugee_id"], name: "index_dossier_numbers_on_refugee_id", using: :btree

  create_table "genders", force: :cascade do |t|
    t.string   "name",       limit: 191
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "homes", force: :cascade do |t|
    t.string   "name",             limit: 191
    t.string   "phone",            limit: 191
    t.string   "fax",              limit: 191
    t.string   "address",          limit: 191
    t.string   "post_code",        limit: 191
    t.string   "postal_town",      limit: 191
    t.integer  "seats",            limit: 4
    t.integer  "guaranteed_seats", limit: 4
    t.integer  "movable_seats",    limit: 4
    t.string   "languages",        limit: 191
    t.text     "comment",          limit: 65535
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "homes", ["name"], name: "index_homes_on_name", unique: true, using: :btree

  create_table "homes_languages", id: false, force: :cascade do |t|
    t.integer "home_id",     limit: 4
    t.integer "language_id", limit: 4
  end

  add_index "homes_languages", ["home_id"], name: "index_homes_languages_on_home_id", using: :btree
  add_index "homes_languages", ["language_id"], name: "index_homes_languages_on_language_id", using: :btree

  create_table "homes_owner_types", id: false, force: :cascade do |t|
    t.integer "home_id",       limit: 4
    t.integer "owner_type_id", limit: 4
  end

  add_index "homes_owner_types", ["home_id"], name: "index_homes_owner_types_on_home_id", using: :btree
  add_index "homes_owner_types", ["owner_type_id"], name: "index_homes_owner_types_on_owner_type_id", using: :btree

  create_table "homes_target_groups", id: false, force: :cascade do |t|
    t.integer "home_id",         limit: 4
    t.integer "target_group_id", limit: 4
  end

  add_index "homes_target_groups", ["home_id"], name: "index_homes_target_groups_on_home_id", using: :btree
  add_index "homes_target_groups", ["target_group_id"], name: "index_homes_target_groups_on_target_group_id", using: :btree

  create_table "homes_type_of_housings", id: false, force: :cascade do |t|
    t.integer "home_id",            limit: 4
    t.integer "type_of_housing_id", limit: 4
  end

  add_index "homes_type_of_housings", ["home_id"], name: "index_homes_type_of_housings_on_home_id", using: :btree
  add_index "homes_type_of_housings", ["type_of_housing_id"], name: "index_homes_type_of_housings_on_type_of_housing_id", using: :btree

  create_table "languages", force: :cascade do |t|
    t.string   "name",       limit: 191
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "languages", ["name"], name: "index_languages_on_name", unique: true, using: :btree

  create_table "languages_refugees", id: false, force: :cascade do |t|
    t.integer  "language_id", limit: 4
    t.integer  "refugee_id",  limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "languages_refugees", ["language_id"], name: "index_languages_refugees_on_language_id", using: :btree
  add_index "languages_refugees", ["refugee_id"], name: "index_languages_refugees_on_refugee_id", using: :btree

  create_table "owner_types", force: :cascade do |t|
    t.string   "name",       limit: 191
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "owner_types", ["name"], name: "index_owner_types_on_name", unique: true, using: :btree

  create_table "refugees", force: :cascade do |t|
    t.string   "name",                limit: 191
    t.date     "registered"
    t.date     "deregistered"
    t.text     "deregistered_reason", limit: 65535
    t.boolean  "special_needs"
    t.text     "comment",             limit: 65535
    t.integer  "gender_id",           limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "refugees", ["gender_id"], name: "index_refugees_on_gender_id", using: :btree

  create_table "ssns", force: :cascade do |t|
    t.string   "name",       limit: 191
    t.integer  "refugee_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "ssns", ["refugee_id"], name: "index_ssns_on_refugee_id", using: :btree

  create_table "target_groups", force: :cascade do |t|
    t.string   "name",       limit: 191
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "target_groups", ["name"], name: "index_target_groups_on_name", unique: true, using: :btree

  create_table "type_of_housings", force: :cascade do |t|
    t.string   "name",       limit: 191
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "type_of_housings", ["name"], name: "index_type_of_housings_on_name", unique: true, using: :btree

  add_foreign_key "assignments", "moved_out_reasons"
  add_foreign_key "refugees", "genders"
end
