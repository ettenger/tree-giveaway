class AddDifferentAddressToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :different_address, :boolean
  end
end
