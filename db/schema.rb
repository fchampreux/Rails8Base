# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_05_133843) do
  create_schema "rails_app"

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "users", id: :serial, force: :cascade do |t|
    t.datetime "active_from", comment: "Starting timestamp of the validity period"
    t.datetime "active_to", comment: "Ending timestamp of the validity period"
    t.string "code", limit: 64, default: "", null: false, comment: "User code, may be used for identification"
    t.datetime "confirmation_sent_at", comment: "Track email confirmation expedition timestamp (Devise)"
    t.string "confirmation_token", comment: "Check against this token for validating email confirmation (Devise)"
    t.datetime "confirmed_at", comment: "Track email confirmation timestamp (Devise)"
    t.datetime "created_at", null: false, comment: "Record activity trace (just as for every object)"
    t.integer "created_by_id", null: false, comment: "Account creator id (just as for every object)"
    t.datetime "current_sign_in_at", comment: "Trace account activity : sign-in timestamp (Devise)"
    t.string "current_sign_in_ip", comment: "Trace account activity : sign-in IP (Devise)"
    t.json "description", comment: "JSON field contains translated descriptions (just as for every object)"
    t.string "email", limit: 255, default: "", null: false, comment: "User email, may be used for identification"
    t.string "encrypted_password", default: "", null: false, comment: "User password, encrypted credential"
    t.integer "failed_attempts", default: 0, null: false, comment: "Trace sign-in attemps count (Devise)"
    t.string "first_name", limit: 255, comment: "User first name (informational)"
    t.boolean "is_active", default: false, null: false, comment: "Account validity flag (just as for every object)"
    t.string "last_name", limit: 255, comment: "User last name (informational)"
    t.datetime "last_sign_in_at", comment: "Trace account activity : last sign-in timestamp (Devise)"
    t.string "last_sign_in_ip", comment: "Trace account activity : last sign-in IP (Devise)"
    t.datetime "locked_at", comment: "Track account lock timestamp (Devise)"
    t.string "middle_name", limit: 255, comment: "User middle name or alias (informational)"
    t.integer "owner_id", null: false, comment: "Account owner id (just as for every object)"
    t.datetime "remember_created_at", comment: "Track when remember-me was activated (Devise)"
    t.datetime "reset_password_sent_at", comment: "Track reset request timestamp for token expiration (Devise)"
    t.string "reset_password_token", comment: "Check against this token for validating reset request (Devise)"
    t.integer "sign_in_count", default: 0, null: false, comment: "Trace account activity : sign-in count (Devise)"
    t.string "unconfirmed_email", comment: "Missing email confirmation (Devise)"
    t.string "unlock_token", comment: "Check against this token for validating unlock request (Devise)"
    t.datetime "updated_at", null: false, comment: "Record activity trace (just as for every object)"
    t.integer "updated_by_id", null: false, comment: "Account editor id (just as for every object)"
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false, comment: "Account uuid (for integration purpose)"
    t.index ["code"], name: "index_users_on_code", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["created_by_id"], name: "index_users_on_created_by_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["is_active"], name: "index_users_on_is_active"
    t.index ["owner_id"], name: "index_users_on_owner_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["updated_by_id"], name: "index_users_on_updated_by_id"
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

  add_foreign_key "users", "users", column: "created_by_id"
  add_foreign_key "users", "users", column: "owner_id"
  add_foreign_key "users", "users", column: "updated_by_id"
end
