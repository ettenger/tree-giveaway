class ChangeColumnsToBoolean < ActiveRecord::Migration
  def change
    change_table :giveaways do |t|
      t.change :no_referral, :boolean
      t.change :no_philly_validation, :boolean
    end
  end
  
end
