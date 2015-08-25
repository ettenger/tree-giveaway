class CreateStoredTexts < ActiveRecord::Migration
  def change
    create_table :stored_texts do |t|
      t.string :name
      t.text :the_text

      t.timestamps null: false
    end
  end
end
