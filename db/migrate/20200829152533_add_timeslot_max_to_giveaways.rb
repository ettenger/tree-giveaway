class AddTimeslotMaxToGiveaways < ActiveRecord::Migration
  def change
    add_column :giveaways, :max_reservations_per_timeslot, :integer
  end
end
