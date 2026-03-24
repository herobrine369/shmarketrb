class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.string :category
      t.string :state
      t.string :condition
      t.decimal :price
      t.date :post_date

      t.timestamps
    end
  end
end
