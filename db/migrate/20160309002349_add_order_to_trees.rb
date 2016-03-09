class AddOrderToTrees < ActiveRecord::Migration
  def change
    add_column :trees, :order, :integer
  end
end
