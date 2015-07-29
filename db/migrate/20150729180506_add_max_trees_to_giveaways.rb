class AddMaxTreesToGiveaways < ActiveRecord::Migration
  def change
    add_column :giveaways, :max_trees, :integer
  end
end
