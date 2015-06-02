class Giveaway < ActiveRecord::Base
  has_and_belongs_to_many :trees
  has_many :requests
end
