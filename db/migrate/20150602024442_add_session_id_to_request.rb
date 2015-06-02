class AddSessionIdToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :session_id, :string
  end
end
