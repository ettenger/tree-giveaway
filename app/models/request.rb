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

  def mailing_address
    "#{self.mailing_street1} #{self.mailing_street2}\n#{self.mailing_city}, #{self.mailing_state} #{self.mailing_zip}"
  end

  def planting_address
    "#{self.planting_street1} #{self.planting_street2}\n#{self.planting_city}, #{self.planting_state} #{self.planting_zip}"
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |request|
        csv << request.attributes.values_at(*column_names)
      end
    end
  end
end
