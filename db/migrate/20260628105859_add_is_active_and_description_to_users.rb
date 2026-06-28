class AddIsActiveAndDescriptionToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :is_active,   :boolean, null: false, default: true
    add_column :users, :description, :json
  end
end
