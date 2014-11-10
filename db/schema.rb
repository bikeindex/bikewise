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

ActiveRecord::Schema.define(version: 20141027142117) do

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
    t.string   "image_url"
    t.string   "image_url_thumb"
    t.text     "title"
    t.text     "description"
    t.string   "type_name"
    t.datetime "occurred_at"
    t.boolean  "create_open311_report",   default: false, null: false
    t.boolean  "has_open311_report",      default: false, null: false
    t.boolean  "open311_is_acknowledged"
    t.boolean  "open311_is_closed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source_type"
    t.text     "source"
    t.text     "additional_sources"
    t.integer  "user_id"
  end

  add_index "incidents", ["country_id"], name: "index_incidents_on_country_id", using: :btree
  add_index "incidents", ["incident_type_id"], name: "index_incidents_on_incident_type_id", using: :btree
  add_index "incidents", ["latitude", "longitude"], name: "index_incidents_on_latitude_and_longitude", using: :btree
  add_index "incidents", ["user_id"], name: "index_incidents_on_user_id", using: :btree

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

  create_table "users", force: true do |t|
    t.string   "email",                    default: "",    null: false
    t.string   "encrypted_password",       default: "",    null: false
    t.string   "binx_id"
    t.text     "binx_bike_ids"
    t.text     "additional_emails"
    t.text     "email_confirmation_token"
    t.string   "provider"
    t.text     "uid"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.boolean  "admin",                    default: false, null: false
    t.text     "access_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
