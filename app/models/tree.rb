class Tree < ActiveRecord::Base
  has_and_belongs_to_many :giveaways
  has_many :requests
end
