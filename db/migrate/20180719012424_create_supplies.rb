class CreateSupplies < ActiveRecord::Migration[5.1]
  def change
    create_table :supplies do |t|
      t.references :book, foreign_key: true
      t.references :shop, foreign_key: true
      t.integer :books_supplied, null: false, default: 0
      t.integer :books_sold, null: false, default: 0

      t.timestamps
    end
  end
end
