class AddTimeslotsToGiveaways < ActiveRecord::Migration
  def change
    add_column :giveaways, :use_timeslots, :boolean
    add_column :giveaways, :timeslots, :text
    add_column :requests, :timeslot, :string
  end
end
