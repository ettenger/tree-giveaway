class Request < ActiveRecord::Base
  has_one :tree
  has_one :giveaway
end
