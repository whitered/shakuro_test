class AddIndexToSupplies < ActiveRecord::Migration[5.1]
  def change
    add_index :supplies, [:book_id, :shop_id], unique: true
  end
end
