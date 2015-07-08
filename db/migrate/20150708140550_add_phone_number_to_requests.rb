class AddPhoneNumberToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :phone_number, :string
  end
end
