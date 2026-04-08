class AddCollegeToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :college, :string
  end
end
