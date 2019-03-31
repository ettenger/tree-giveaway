class AddOptionsToGiveaways < ActiveRecord::Migration
  def change
    add_column :giveaways, :ask_if_cell_phone, :boolean
    add_column :giveaways, :ask_if_attended, :boolean
    add_column :giveaways, :require_referral, :boolean
  end
end
