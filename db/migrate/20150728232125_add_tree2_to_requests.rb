class AddTree2ToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :tree2_id, :integer
  end
end
