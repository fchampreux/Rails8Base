class AlignUsersWithSeed < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :code,       :string, limit: 255, null: false, default: ""
    add_column :users, :active_from, :date
    add_column :users, :active_to,   :date
    add_column :users, :created_by,  :string, limit: 255
    add_column :users, :updated_by,  :string, limit: 255
    add_index  :users, :code, unique: true

    remove_column :users, :password, :string
  end
end
