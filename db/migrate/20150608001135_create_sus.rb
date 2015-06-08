class CreateSus < ActiveRecord::Migration
  def change
    create_table :sus do |t|
      t.string :session_id
      t.string :password

      t.timestamps null: false
    end
  end
end
