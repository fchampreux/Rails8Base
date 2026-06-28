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

ActiveRecord::Schema[8.1].define(version: 2026_06_28_105859) do
  create_schema "rails_app"

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "users", id: :serial, force: :cascade do |t|
    t.date "active_from"
    t.date "active_to"
    t.string "code", limit: 255, default: "", null: false
    t.datetime "created_at", null: false
    t.integer "created_by_id"
    t.json "description"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", limit: 255
    t.boolean "is_active", default: true, null: false
    t.string "last_name", limit: 255
    t.integer "owner_id"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.integer "updated_by_id"
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.index ["code"], name: "index_users_on_code", unique: true
    t.index ["created_by_id"], name: "index_users_on_created_by_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["owner_id"], name: "index_users_on_owner_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["updated_by_id"], name: "index_users_on_updated_by_id"
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

  add_foreign_key "users", "users", column: "created_by_id"
  add_foreign_key "users", "users", column: "owner_id"
  add_foreign_key "users", "users", column: "updated_by_id"
end
