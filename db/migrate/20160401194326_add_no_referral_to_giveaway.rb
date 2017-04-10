class AddNoReferralToGiveaway < ActiveRecord::Migration
  def change
    add_column :giveaways, :no_referral, :binary
  end
end
