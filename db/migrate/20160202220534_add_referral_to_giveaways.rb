class AddReferralToGiveaways < ActiveRecord::Migration
  def change
    add_column :giveaways, :referral, :text
  end
end
