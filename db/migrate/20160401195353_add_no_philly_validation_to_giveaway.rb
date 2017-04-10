class AddNoPhillyValidationToGiveaway < ActiveRecord::Migration
  def change
    add_column :giveaways, :no_philly_validation, :binary
  end
end
