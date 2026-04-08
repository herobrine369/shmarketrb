class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.references :seller, null: false, foreign_key: { to_table: :users }
      t.references :buyer, null: false, foreign_key: { to_table: :users }
      t.references :product, null: false, foreign_key: true

      t.boolean :is_successful, default: false

      t.timestamps
    end
  end
end
