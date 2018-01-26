class AddFieldsToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :is_cell_phone, :boolean
    add_column :requests, :previously_attended, :string
  end
end
