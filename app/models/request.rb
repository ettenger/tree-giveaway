class Request < ActiveRecord::Base
  belongs_to :tree
  belongs_to :giveaway

  validates :first_name, :last_name, presence: true
  validates :tree_id, presence: { message: "Please select a tree" }, numericality: { only_integer: true }
  validates :email,
            uniqueness: true,
            presence: true,
            :email_format => { :message => "Invalid email address" }
end
