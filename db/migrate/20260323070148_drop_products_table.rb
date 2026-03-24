class DropProductsTable < ActiveRecord::Migration[8.1]
  def change
    drop_table :products
  end
end
