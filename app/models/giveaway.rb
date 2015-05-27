class Giveaway < ActiveRecord::Base
  has_and_belongs_to_many :trees
  belongs_to :request
end
