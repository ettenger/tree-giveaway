class AddAddressesToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :mailing_street1, :string
    add_column :requests, :mailing_street2, :string
    add_column :requests, :mailing_city, :string
    add_column :requests, :mailing_state, :string
    add_column :requests, :mailing_zip, :string
    add_column :requests, :planting_street1, :string
    add_column :requests, :planting_street2, :string
    add_column :requests, :planting_city, :string
    add_column :requests, :planting_state, :string
    add_column :requests, :planting_zip, :string
  end
end
