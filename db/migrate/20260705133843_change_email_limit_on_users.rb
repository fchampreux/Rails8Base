class ChangeEmailLimitOnUsers < ActiveRecord::Migration[8.1]
  def change
    change_column :users, :email, :string, limit: 255, null: false, default: "", comment: "User email, may be used for identification"
  end
end
