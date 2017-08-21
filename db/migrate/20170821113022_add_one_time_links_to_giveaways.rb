class AddOneTimeLinksToGiveaways < ActiveRecord::Migration
  def change
    add_column :giveaways, :use_one_time_links, :boolean
    add_column :giveaways, :valid_codes, :text
    add_column :giveaways, :used_codes, :text
  end
end
