class AddOriginalStockToTrees < ActiveRecord::Migration
  def change
    add_column :trees, :original_stock, :integer
  end
end
