class AddDeliveryToGiveaways < ActiveRecord::Migration
  def change
    add_column :giveaways, :use_delivery, :boolean
    add_column :giveaways, :max_delivery_registrations, :integer
    add_column :giveaways, :pickup_delivery_text, :text
    add_column :requests, :is_delivery, :boolean
  end
end
