class ChangeIsActiveDefaultAndAddFlagIndexesToUsers < ActiveRecord::Migration[8.1]
  def change
    change_column_default :users, :is_active, from: true, to: false

    add_index :users, :is_active
  end
end
