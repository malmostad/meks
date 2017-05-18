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

ActiveRecord::Schema.define(version: 20170518152931) do

  create_table "costs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci" do |t|
    t.integer  "amount"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "home_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["home_id"], name: "index_costs_on_home_id", using: :btree
  end

  create_table "countries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_countries_on_name", unique: true, using: :btree
  end

  create_table "countries_homes", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.integer "country_id"
    t.integer "home_id"
    t.index ["country_id"], name: "index_countries_homes_on_country_id", using: :btree
    t.index ["home_id"], name: "index_countries_homes_on_home_id", using: :btree
  end

  create_table "countries_refugees", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.integer  "country_id"
    t.integer  "refugee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_countries_refugees_on_country_id", using: :btree
    t.index ["refugee_id"], name: "index_countries_refugees_on_refugee_id", using: :btree
  end

  create_table "delayed_jobs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.integer  "priority",                 default: 0, null: false
    t.integer  "attempts",                 default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "deregistered_reasons", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.string "name"
    t.index ["name"], name: "index_deregistered_reasons_on_name", unique: true, using: :btree
  end

  create_table "dossier_numbers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.string   "name"
    t.integer  "refugee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_dossier_numbers_on_name", unique: true, using: :btree
    t.index ["refugee_id"], name: "index_dossier_numbers_on_refugee_id", using: :btree
  end

  create_table "genders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_genders_on_name", unique: true, using: :btree
  end

  create_table "homes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "fax"
    t.string   "address"
    t.string   "post_code"
    t.string   "postal_town"
    t.integer  "owner_type_id"
    t.integer  "guaranteed_seats"
    t.integer  "movable_seats"
    t.boolean  "active",                                    default: true
    t.string   "languages"
    t.text     "comment",                     limit: 65535
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.boolean  "use_placement_specification",               default: false
    t.boolean  "use_placement_cost",                        default: false
    t.index ["name"], name: "index_homes_on_name", unique: true, using: :btree
    t.index ["owner_type_id"], name: "index_homes_on_owner_type_id", using: :btree
  end

  create_table "homes_languages", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.integer "home_id"
    t.integer "language_id"
    t.index ["home_id"], name: "index_homes_languages_on_home_id", using: :btree
    t.index ["language_id"], name: "index_homes_languages_on_language_id", using: :btree
  end

  create_table "homes_target_groups", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.integer "home_id"
    t.integer "target_group_id"
    t.index ["home_id"], name: "index_homes_target_groups_on_home_id", using: :btree
    t.index ["target_group_id"], name: "index_homes_target_groups_on_target_group_id", using: :btree
  end

  create_table "homes_type_of_housings", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.integer "home_id"
    t.integer "type_of_housing_id"
    t.index ["home_id"], name: "index_homes_type_of_housings_on_home_id", using: :btree
    t.index ["type_of_housing_id"], name: "index_homes_type_of_housings_on_type_of_housing_id", using: :btree
  end

  create_table "languages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_languages_on_name", unique: true, using: :btree
  end

  create_table "languages_refugees", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.integer  "language_id"
    t.integer  "refugee_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["language_id"], name: "index_languages_refugees_on_language_id", using: :btree
    t.index ["refugee_id"], name: "index_languages_refugees_on_refugee_id", using: :btree
  end

  create_table "legal_codes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_legal_codes_on_name", unique: true, using: :btree
  end

  create_table "moved_out_reasons", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_moved_out_reasons_on_name", unique: true, using: :btree
  end

  create_table "municipalities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_municipalities_on_name", unique: true, using: :btree
  end

  create_table "owner_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_owner_types_on_name", unique: true, using: :btree
  end

  create_table "payment_imports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.integer  "user_id"
    t.datetime "imported_at"
    t.integer  "number_of_records"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["user_id"], name: "index_payment_imports_on_user_id", using: :btree
  end

  create_table "payments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.integer  "refugee_id"
    t.string   "diarie"
    t.datetime "period_start"
    t.datetime "period_end"
    t.float    "amount",            limit: 24
    t.integer  "payment_import_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["payment_import_id"], name: "index_payments_on_payment_import_id", using: :btree
    t.index ["refugee_id"], name: "index_payments_on_refugee_id", using: :btree
  end

  create_table "placements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.integer  "home_id"
    t.integer  "refugee_id"
    t.date     "moved_in_at"
    t.date     "moved_out_at"
    t.integer  "moved_out_reason_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.text     "specification",       limit: 65535
    t.integer  "legal_code_id"
    t.integer  "cost"
    t.index ["home_id"], name: "index_placements_on_home_id", using: :btree
    t.index ["legal_code_id"], name: "index_placements_on_legal_code_id", using: :btree
    t.index ["moved_out_reason_id"], name: "index_placements_on_moved_out_reason_id", using: :btree
    t.index ["refugee_id"], name: "index_placements_on_refugee_id", using: :btree
  end

  create_table "rate_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci" do |t|
    t.string   "name"
    t.integer  "from_age"
    t.integer  "to_age"
    t.text     "description",   limit: 65535
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "legal_code_id"
    t.index ["legal_code_id"], name: "index_rate_categories_on_legal_code_id", using: :btree
  end

  create_table "rates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci" do |t|
    t.integer  "amount"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "rate_category_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["rate_category_id"], name: "index_rates_on_rate_category_id", using: :btree
  end

  create_table "refugees", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.boolean  "draft",                                                    default: false
    t.string   "name"
    t.date     "date_of_birth"
    t.string   "ssn_extension"
    t.string   "dossier_number"
    t.date     "registered"
    t.date     "deregistered"
    t.date     "residence_permit_at"
    t.date     "checked_out_to_our_city"
    t.date     "temporary_permit_starts_at"
    t.date     "temporary_permit_ends_at"
    t.integer  "municipality_id"
    t.date     "municipality_placement_migrationsverket_at"
    t.date     "municipality_placement_per_agreement_at"
    t.text     "municipality_placement_comment",             limit: 65535
    t.boolean  "special_needs"
    t.text     "other_relateds",                             limit: 65535
    t.integer  "gender_id"
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
    t.integer  "deregistered_reason_id"
    t.boolean  "secrecy",                                                  default: false
    t.text     "social_worker",                              limit: 65535
    t.text     "deregistered_comment",                       limit: 65535
    t.date     "citizenship_at"
    t.boolean  "sof_placement",                                            default: false
    t.index ["deregistered_reason_id"], name: "index_refugees_on_deregistered_reason_id", using: :btree
    t.index ["gender_id"], name: "index_refugees_on_gender_id", using: :btree
    t.index ["municipality_id"], name: "index_refugees_on_municipality_id", using: :btree
  end

  create_table "relationships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.integer  "refugee_id"
    t.integer  "related_id"
    t.integer  "type_of_relationship_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["refugee_id", "related_id"], name: "index_relationships_on_refugee_id_and_related_id", unique: true, using: :btree
    t.index ["refugee_id"], name: "index_relationships_on_refugee_id", using: :btree
    t.index ["related_id"], name: "index_relationships_on_related_id", using: :btree
    t.index ["type_of_relationship_id"], name: "index_relationships_on_type_of_relationship_id", using: :btree
  end

  create_table "ssns", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.date     "date_of_birth"
    t.string   "extension"
    t.integer  "refugee_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["refugee_id"], name: "index_ssns_on_refugee_id", using: :btree
  end

  create_table "target_groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_target_groups_on_name", unique: true, using: :btree
  end

  create_table "type_of_housings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_type_of_housings_on_name", unique: true, using: :btree
  end

  create_table "type_of_relationships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_type_of_relationships_on_name", unique: true, using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci" do |t|
    t.string   "username"
    t.string   "name"
    t.string   "email"
    t.string   "role"
    t.string   "ip"
    t.datetime "last_login"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  add_foreign_key "costs", "homes"
  add_foreign_key "homes", "owner_types"
  add_foreign_key "payment_imports", "users"
  add_foreign_key "payments", "payment_imports"
  add_foreign_key "payments", "refugees"
  add_foreign_key "placements", "legal_codes"
  add_foreign_key "placements", "moved_out_reasons"
  add_foreign_key "rate_categories", "legal_codes"
  add_foreign_key "rates", "rate_categories"
  add_foreign_key "refugees", "deregistered_reasons"
  add_foreign_key "refugees", "genders"
  add_foreign_key "refugees", "municipalities"
  add_foreign_key "relationships", "type_of_relationships"
end
