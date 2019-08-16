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

ActiveRecord::Schema.define(version: 2019_08_15_095711) do

  create_table "costs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.integer "amount"
    t.date "start_date"
    t.date "end_date"
    t.integer "home_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["home_id"], name: "index_costs_on_home_id"
  end

  create_table "countries", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_countries_on_name", unique: true
  end

  create_table "countries_homes", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.integer "country_id"
    t.integer "home_id"
    t.index ["country_id"], name: "index_countries_homes_on_country_id"
    t.index ["home_id"], name: "index_countries_homes_on_home_id"
  end

  create_table "countries_people", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.integer "country_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_countries_people_on_country_id"
    t.index ["person_id"], name: "index_countries_people_on_person_id"
  end

  create_table "delayed_jobs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "deregistered_reasons", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_deregistered_reasons_on_name", unique: true
  end

  create_table "dossier_numbers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_dossier_numbers_on_name", unique: true
    t.index ["person_id"], name: "index_dossier_numbers_on_person_id"
  end

  create_table "extra_contribution_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "outpatient", default: false
    t.index ["name"], name: "index_extra_contribution_types_on_name", unique: true
  end

  create_table "extra_contributions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.integer "person_id"
    t.bigint "extra_contribution_type_id"
    t.date "period_start"
    t.date "period_end"
    t.decimal "fee", precision: 10, scale: 2
    t.decimal "expense", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "contractor_name"
    t.date "contractor_birthday"
    t.integer "contactor_employee_number"
    t.decimal "monthly_cost", precision: 10, scale: 2
    t.string "comment"
    t.datetime "imported_at"
    t.index ["extra_contribution_type_id"], name: "index_extra_contributions_on_extra_contribution_type_id"
    t.index ["person_id"], name: "index_extra_contributions_on_person_id"
  end

  create_table "family_and_emergency_home_costs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.integer "placement_id"
    t.date "period_start"
    t.date "period_end"
    t.decimal "fee", precision: 10, scale: 2
    t.decimal "expense", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "contractor_name"
    t.date "contractor_birthday"
    t.integer "contactor_employee_number"
    t.index ["placement_id"], name: "index_family_and_emergency_home_costs_on_placement_id"
  end

  create_table "genders", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_genders_on_name", unique: true
  end

  create_table "homes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "fax"
    t.string "address"
    t.string "post_code"
    t.string "postal_town"
    t.integer "owner_type_id"
    t.integer "guaranteed_seats"
    t.integer "movable_seats"
    t.boolean "active", default: true
    t.string "languages"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "use_placement_specification", default: false
    t.boolean "use_placement_cost", default: false
    t.integer "type_of_cost"
    t.index ["name"], name: "index_homes_on_name", unique: true
    t.index ["owner_type_id"], name: "index_homes_on_owner_type_id"
  end

  create_table "homes_languages", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.integer "home_id"
    t.integer "language_id"
    t.index ["home_id"], name: "index_homes_languages_on_home_id"
    t.index ["language_id"], name: "index_homes_languages_on_language_id"
  end

  create_table "homes_target_groups", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.integer "home_id"
    t.integer "target_group_id"
    t.index ["home_id"], name: "index_homes_target_groups_on_home_id"
    t.index ["target_group_id"], name: "index_homes_target_groups_on_target_group_id"
  end

  create_table "homes_type_of_housings", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.integer "home_id"
    t.integer "type_of_housing_id"
    t.index ["home_id"], name: "index_homes_type_of_housings_on_home_id"
    t.index ["type_of_housing_id"], name: "index_homes_type_of_housings_on_type_of_housing_id"
  end

  create_table "languages", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_languages_on_name", unique: true
  end

  create_table "languages_people", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.integer "language_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_languages_people_on_language_id"
    t.index ["person_id"], name: "index_languages_people_on_person_id"
  end

  create_table "legal_codes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "pre_selected", default: false
    t.boolean "exempt_from_rate", default: false
    t.index ["name"], name: "index_legal_codes_on_name", unique: true
  end

  create_table "moved_out_reasons", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_moved_out_reasons_on_name", unique: true
  end

  create_table "municipalities", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "our_municipality"
    t.index ["name"], name: "index_municipalities_on_name", unique: true
  end

  create_table "one_time_payments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci", force: :cascade do |t|
    t.integer "amount"
    t.date "start_date"
    t.date "end_date"
  end

  create_table "owner_types", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_owner_types_on_name", unique: true
  end

  create_table "payment_imports", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "imported_at"
    t.text "warnings"
    t.string "content_type"
    t.string "original_filename"
    t.text "raw", limit: 16777215
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_payment_imports_on_user_id"
  end

  create_table "payments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.integer "person_id"
    t.date "period_start"
    t.date "period_end"
    t.decimal "amount", precision: 12, scale: 2
    t.integer "payment_import_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "comment"
    t.index ["payment_import_id"], name: "index_payments_on_payment_import_id"
    t.index ["person_id"], name: "index_payments_on_person_id"
  end

  create_table "people", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.boolean "draft", default: false
    t.string "name"
    t.date "date_of_birth"
    t.string "ssn_extension"
    t.string "dossier_number"
    t.date "registered"
    t.date "deregistered"
    t.date "residence_permit_at"
    t.date "checked_out_to_our_city"
    t.date "temporary_permit_starts_at"
    t.date "temporary_permit_ends_at"
    t.integer "municipality_id"
    t.date "municipality_placement_migrationsverket_at"
    t.text "municipality_placement_comment"
    t.boolean "special_needs"
    t.text "other_relateds"
    t.integer "gender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "deregistered_reason_id"
    t.boolean "secrecy", default: false
    t.text "social_worker"
    t.text "deregistered_comment"
    t.date "citizenship_at"
    t.boolean "sof_placement", default: false
    t.boolean "arrival"
    t.string "procapita"
    t.datetime "imported_at"
    t.boolean "transferred"
    t.boolean "ekb", default: true
    t.index ["deregistered_reason_id"], name: "index_people_on_deregistered_reason_id"
    t.index ["gender_id"], name: "index_people_on_gender_id"
    t.index ["municipality_id"], name: "index_people_on_municipality_id"
  end

  create_table "person_extra_costs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.integer "person_id"
    t.date "date"
    t.decimal "amount", precision: 10, scale: 2
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_person_extra_costs_on_person_id"
  end

  create_table "placement_extra_costs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.integer "placement_id"
    t.date "date"
    t.decimal "amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "comment"
    t.index ["placement_id"], name: "index_placement_extra_costs_on_placement_id"
  end

  create_table "placements", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.integer "home_id"
    t.integer "person_id"
    t.date "moved_in_at"
    t.date "moved_out_at"
    t.integer "moved_out_reason_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "specification"
    t.integer "legal_code_id"
    t.integer "cost"
    t.datetime "imported_at"
    t.index ["home_id"], name: "index_placements_on_home_id"
    t.index ["legal_code_id"], name: "index_placements_on_legal_code_id"
    t.index ["moved_out_reason_id"], name: "index_placements_on_moved_out_reason_id"
    t.index ["person_id"], name: "index_placements_on_person_id"
  end

  create_table "po_rates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.decimal "rate_under_65", precision: 5, scale: 2
    t.decimal "rate_between_65_and_81", precision: 5, scale: 2
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "rate_from_82", precision: 5, scale: 2
  end

  create_table "rate_categories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "human_name"
    t.integer "qualifier"
  end

  create_table "rates", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.integer "amount"
    t.date "start_date"
    t.date "end_date"
    t.integer "rate_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rate_category_id"], name: "index_rates_on_rate_category_id"
  end

  create_table "relationships", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.integer "person_id"
    t.integer "related_id"
    t.integer "type_of_relationship_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id", "related_id"], name: "index_relationships_on_person_id_and_related_id", unique: true
    t.index ["person_id"], name: "index_relationships_on_person_id"
    t.index ["related_id"], name: "index_relationships_on_related_id"
    t.index ["type_of_relationship_id"], name: "index_relationships_on_type_of_relationship_id"
  end

  create_table "settings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.string "key"
    t.string "human_name"
    t.string "value"
    t.datetime "updated_at", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_settings_on_key", unique: true
  end

  create_table "ssns", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.date "date_of_birth"
    t.string "extension"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_ssns_on_person_id"
  end

  create_table "target_groups", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_target_groups_on_name", unique: true
  end

  create_table "type_of_housings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_type_of_housings_on_name", unique: true
  end

  create_table "type_of_relationships", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_type_of_relationships_on_name", unique: true
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci", force: :cascade do |t|
    t.string "username"
    t.string "name"
    t.string "email"
    t.string "role"
    t.string "ip"
    t.datetime "last_login"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "costs", "homes"
  add_foreign_key "extra_contributions", "extra_contribution_types"
  add_foreign_key "extra_contributions", "people"
  add_foreign_key "family_and_emergency_home_costs", "placements"
  add_foreign_key "homes", "owner_types"
  add_foreign_key "payment_imports", "users"
  add_foreign_key "payments", "payment_imports"
  add_foreign_key "payments", "people"
  add_foreign_key "people", "deregistered_reasons"
  add_foreign_key "people", "genders"
  add_foreign_key "people", "municipalities"
  add_foreign_key "person_extra_costs", "people"
  add_foreign_key "placement_extra_costs", "placements"
  add_foreign_key "placements", "legal_codes"
  add_foreign_key "placements", "moved_out_reasons"
  add_foreign_key "rates", "rate_categories"
  add_foreign_key "relationships", "type_of_relationships"
end
