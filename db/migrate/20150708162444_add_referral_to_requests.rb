class AddReferralToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :referral, :text
  end
end
