class AddLogosToGiveaways < ActiveRecord::Migration
  def change
    add_column :giveaways, :logo1_id, :integer
    add_column :giveaways, :logo2_id, :integer
    add_column :giveaways, :logo3_id, :integer
    add_column :giveaways, :logo4_id, :integer
    add_column :giveaways, :logo5_id, :integer
    add_column :giveaways, :logo6_id, :integer
  end
end
