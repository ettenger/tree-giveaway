class AddDescAndEndTimeToGiveaways < ActiveRecord::Migration
  def change
    add_column :giveaways, :description2, :text
    add_column :giveaways, :end_time, :datetime
  end
end
