class CreateGiveaways < ActiveRecord::Migration
  def change
    create_table :giveaways do |t|
      t.string :name
      t.text :description
      t.string :location
      t.datetime :time

      t.timestamps null: false
    end
  end
end
