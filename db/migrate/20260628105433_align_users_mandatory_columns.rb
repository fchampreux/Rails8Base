class AlignUsersMandatoryColumns < ActiveRecord::Migration[8.1]
  def change
    # Enable pgcrypto for gen_random_uuid() if not already active
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")

    # Replace string audit columns with proper FK integer columns
    remove_column :users, :created_by, :string
    remove_column :users, :updated_by, :string

    add_column :users, :uuid,          :uuid,    null: false, default: "gen_random_uuid()"
    add_column :users, :owner_id,      :integer
    add_column :users, :created_by_id, :integer
    add_column :users, :updated_by_id, :integer

    add_index :users, :uuid,          unique: true
    add_index :users, :owner_id
    add_index :users, :created_by_id
    add_index :users, :updated_by_id

    # Nullable FKs: self-referential table cannot enforce NOT NULL at bootstrap
    add_foreign_key :users, :users, column: :owner_id
    add_foreign_key :users, :users, column: :created_by_id
    add_foreign_key :users, :users, column: :updated_by_id
  end
end
