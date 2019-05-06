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

ActiveRecord::Schema.define(version: 20190506213912) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "binx_reports", force: true do |t|
    t.integer  "external_api_id"
    t.text     "external_api_hash"
    t.datetime "external_api_updated_at"
    t.datetime "external_api_checked_at"
    t.boolean  "processed",               default: false, null: false
    t.boolean  "should_create_incident",  default: true
    t.integer  "binx_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bw_reports", force: true do |t|
    t.integer  "external_api_id"
    t.text     "external_api_hash"
    t.datetime "external_api_updated_at"
    t.datetime "external_api_checked_at"
    t.boolean  "processed",               default: false, null: false
    t.boolean  "should_create_incident",  default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", force: true do |t|
    t.string   "name"
    t.string   "iso"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "crashes", force: true do |t|
    t.boolean  "rain"
    t.boolean  "snow"
    t.boolean  "fog"
    t.boolean  "wind"
    t.boolean  "lights"
    t.boolean  "helmet"
    t.integer  "injury_severity_select_id"
    t.integer  "lighting_select_id"
    t.integer  "visibility_select_id"
    t.integer  "condition_select_id"
    t.integer  "geometry_select_id"
    t.text     "conditions_description"
    t.text     "injury_description"
    t.integer  "crash_select_id"
    t.integer  "vehicle_select_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "crashes", ["condition_select_id"], name: "index_crashes_on_condition_select_id", using: :btree
  add_index "crashes", ["crash_select_id"], name: "index_crashes_on_crash_select_id", using: :btree
  add_index "crashes", ["geometry_select_id"], name: "index_crashes_on_geometry_select_id", using: :btree
  add_index "crashes", ["injury_severity_select_id"], name: "index_crashes_on_injury_severity_select_id", using: :btree
  add_index "crashes", ["lighting_select_id"], name: "index_crashes_on_lighting_select_id", using: :btree
  add_index "crashes", ["vehicle_select_id"], name: "index_crashes_on_vehicle_select_id", using: :btree
  add_index "crashes", ["visibility_select_id"], name: "index_crashes_on_visibility_select_id", using: :btree

  create_table "hazards", force: true do |t|
    t.integer  "hazard_select_id"
    t.integer  "priority_select_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hazards", ["hazard_select_id"], name: "index_hazards_on_hazard_select_id", using: :btree

  create_table "images", force: true do |t|
    t.string   "image"
    t.string   "name"
    t.integer  "incident_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "import_statuses", force: true do |t|
    t.string   "source"
    t.datetime "checked_updates_at"
    t.text     "info_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "incident_reports", force: true do |t|
    t.integer  "incident_id"
    t.integer  "report_id"
    t.string   "report_type"
    t.boolean  "is_open311_report"
    t.boolean  "is_incident_source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "incident_reports", ["report_id", "report_type"], name: "index_incident_reports_on_report_id_and_report_type", using: :btree

  create_table "incident_types", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "incidents", force: true do |t|
    t.integer  "incident_type_id"
    t.string   "address"
    t.integer  "country_id"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "image_url"
    t.text     "image_url_thumb"
    t.text     "title"
    t.text     "description"
    t.string   "type_name"
    t.datetime "occurred_at"
    t.boolean  "create_open311_report",      default: false, null: false
    t.boolean  "has_open311_report",         default: false, null: false
    t.boolean  "open311_is_acknowledged"
    t.boolean  "open311_is_closed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source_type"
    t.text     "source"
    t.text     "additional_sources"
    t.integer  "user_id"
    t.integer  "experience_level_select_id"
    t.integer  "age"
    t.text     "name"
    t.integer  "gender_select_id"
    t.integer  "type_properties_id"
    t.string   "type_properties_type"
    t.text     "location_description"
    t.integer  "location_select_id"
    t.integer  "occurred_at_stamp"
    t.json     "feature_marker"
  end

  add_index "incidents", ["country_id"], name: "index_incidents_on_country_id", using: :btree
  add_index "incidents", ["experience_level_select_id"], name: "index_incidents_on_experience_level_select_id", using: :btree
  add_index "incidents", ["gender_select_id"], name: "index_incidents_on_gender_select_id", using: :btree
  add_index "incidents", ["incident_type_id"], name: "index_incidents_on_incident_type_id", using: :btree
  add_index "incidents", ["latitude", "longitude"], name: "index_incidents_on_latitude_and_longitude", using: :btree
  add_index "incidents", ["user_id"], name: "index_incidents_on_user_id", using: :btree

  create_table "legacy_bw_reports", force: true do |t|
    t.string   "external_api_id"
    t.text     "external_api_hash"
    t.datetime "external_api_updated_at"
    t.datetime "external_api_checked_at"
    t.boolean  "processed",               default: false, null: false
    t.boolean  "should_create_incident",  default: true
    t.text     "source"
    t.integer  "legacy_bw_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scf_reports", force: true do |t|
    t.integer  "external_api_id"
    t.text     "external_api_hash"
    t.datetime "external_api_updated_at"
    t.datetime "external_api_checked_at"
    t.boolean  "processed",               default: false, null: false
    t.boolean  "should_create_incident",  default: true
    t.boolean  "is_acknowledged"
    t.datetime "acknowledged_at"
    t.boolean  "is_closed"
    t.datetime "closed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "selections", force: true do |t|
    t.string   "name"
    t.string   "select_type"
    t.boolean  "user_created", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "thefts", force: true do |t|
    t.integer  "locking_select_id"
    t.integer  "locking_defeat_select_id"
    t.boolean  "has_police_report"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "thefts", ["locking_defeat_select_id"], name: "index_thefts_on_locking_defeat_select_id", using: :btree
  add_index "thefts", ["locking_select_id"], name: "index_thefts_on_locking_select_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                      default: "",    null: false
    t.string   "encrypted_password",         default: "",    null: false
    t.string   "binx_id"
    t.text     "binx_bike_ids"
    t.text     "email_confirmation_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.boolean  "admin",                      default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "birth_year"
    t.text     "name"
    t.string   "gender"
    t.text     "legacy_bw_hash"
    t.integer  "legacy_bw_id"
    t.integer  "experience_level_select_id"
    t.integer  "gender_select_id"
  end

end
