class AddIsAdminToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :is_admin, :boolean, null: false, default: false, comment: "Administration privileges flag"
    add_index :users, :is_admin
  end
end
