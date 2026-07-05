# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[8.1]
  def change
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")

    create_table :users, id: :serial do |t|
      ## User identification
      t.string :code,     limit: 64, null: false, default: "", comment: "User code, may be used for identification"
      t.string :first_name, limit: 255, comment: "User first name (informational)"
      t.string :middle_name, limit: 255, comment: "User middle name or alias (informational)"
      t.string :last_name,  limit: 255, comment: "User last name (informational)"
      t.datetime :active_from, comment: "Starting timestamp of the validity period"
      t.datetime :active_to, comment: "Ending timestamp of the validity period"

      ## Database authenticatable
      t.string :email,  limit: 255, null: false, default: "", comment: "User email, may be used for identification"
      t.string :encrypted_password, null: false, default: "", comment: "User password, encrypted credential"

      ## Recoverable
      t.string   :reset_password_token, comment: "Check against this token for validating reset request (Devise)"
      t.datetime :reset_password_sent_at, comment: "Track reset request timestamp for token expiration (Devise)"

      ## Rememberable
      t.datetime :remember_created_at, comment: "Track when remember-me was activated (Devise)"

      ## Trackable
      t.integer  :sign_in_count,   default: 0, null: false, comment: "Trace account activity : sign-in count (Devise)"
      t.datetime :current_sign_in_at, comment: "Trace account activity : sign-in timestamp (Devise)"
      t.datetime :last_sign_in_at, comment: "Trace account activity : last sign-in timestamp (Devise)"
      t.string   :current_sign_in_ip, comment: "Trace account activity : sign-in IP (Devise)"
      t.string   :last_sign_in_ip, comment: "Trace account activity : last sign-in IP (Devise)"

      ## Confirmable
      t.string   :confirmation_token, comment: "Check against this token for validating email confirmation (Devise)"
      t.datetime :confirmed_at, comment: "Track email confirmation timestamp (Devise)"
      t.datetime :confirmation_sent_at, comment: "Track email confirmation expedition timestamp (Devise)"
      t.string   :unconfirmed_email, comment: "Missing email confirmation (Devise)"

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false, comment: "Trace sign-in attemps count (Devise)"
      t.string   :unlock_token, comment: "Check against this token for validating unlock request (Devise)"
      t.datetime :locked_at, comment: "Track account lock timestamp (Devise)"

      ## Mandatory columns
      t.uuid    :uuid,          null: false, default: -> { "gen_random_uuid()" }, comment: "Account uuid (for integration purpose)"
      t.integer :owner_id,      null: false, comment: "Account owner id (just as for every object)"
      t.integer :created_by_id, null: false, comment: "Account creator id (just as for every object)"
      t.integer :updated_by_id, null: false, comment: "Account editor id (just as for every object)"
      t.boolean :is_active,     null: false, default: false, comment: "Account validity flag (just as for every object)"
      t.boolean :is_admin,      null: false, default: false, comment: "Administration privileges flag"
      t.json    :description, comment: "JSON field contains translated descriptions (just as for every object)"

      t.timestamps null: false, comment: "Record activity trace (just as for every object)"
    end

    add_index :users, :code,                 unique: true
    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :unlock_token,         unique: true
    add_index :users, :uuid,                 unique: true
    add_index :users, :owner_id
    add_index :users, :created_by_id
    add_index :users, :updated_by_id
    add_index :users, :is_active
    add_index :users, :is_admin

    # Self-referential FKs: bootstrap rows reference themselves (id 0 -> owner_id 0, etc.)
    add_foreign_key :users, :users, column: :owner_id
    add_foreign_key :users, :users, column: :created_by_id
    add_foreign_key :users, :users, column: :updated_by_id
  end
end
