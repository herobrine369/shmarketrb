class SetUsernameOfUsersNotNull < ActiveRecord::Migration[8.1]
  def change
    change_column :users, :username, :string, null: false
  end
end
