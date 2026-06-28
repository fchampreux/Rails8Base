# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[8.1]
  def change
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")

    create_table :users, id: :serial do |t|
      ## User identification
      t.string :code,       limit: 255, null: false, default: ""
      t.string :first_name, limit: 255
      t.string :last_name,  limit: 255
      t.date   :active_from
      t.date   :active_to

      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count,      default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false
      t.string   :unlock_token
      t.datetime :locked_at

      ## Mandatory columns
      t.uuid    :uuid,          null: false, default: -> { "gen_random_uuid()" }
      t.integer :owner_id
      t.integer :created_by_id
      t.integer :updated_by_id
      t.boolean :is_active,     null: false, default: false
      t.json    :description

      t.timestamps null: false
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

    # Nullable FKs: self-referential table cannot enforce NOT NULL at bootstrap
    add_foreign_key :users, :users, column: :owner_id
    add_foreign_key :users, :users, column: :created_by_id
    add_foreign_key :users, :users, column: :updated_by_id
  end
end
