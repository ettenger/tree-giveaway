class AddThingsToGiveaways < ActiveRecord::Migration
  def change
    add_column :giveaways, :tree_limit, :integer
    add_column :giveaways, :close_time, :datetime
    add_column :giveaways, :confirmation_text, :text
  end
end
