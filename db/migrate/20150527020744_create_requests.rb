class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :tree_id
      t.integer :giveaway_id

      t.timestamps null: false
    end
  end
end
