class AddIndexOnUsersNameColumns < ActiveRecord::Migration[8.1]
  def change
    add_index :users, [ :last_name, :first_name ]
  end
end
