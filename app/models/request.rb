class Request < ActiveRecord::Base
  belongs_to :tree
  belongs_to :giveaway

  validates :first_name, :last_name, :phone_number,
            :mailing_street1, :mailing_city, :mailing_state, :mailing_zip,
            :planting_street1, :planting_city, :planting_state, :planting_zip,
            presence: true
  validates :tree_id, presence: { message: "Please select a tree" }, numericality: { only_integer: true }
  validates :email,
            presence: true,
            :email_format => { :message => "Invalid email address" }

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |request|
        csv << request.attributes.values_at(*column_names)
      end
    end
end
end
