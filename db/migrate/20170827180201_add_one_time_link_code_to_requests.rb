class AddOneTimeLinkCodeToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :one_time_link_code, :string
  end
end
