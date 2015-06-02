class Request < ActiveRecord::Base
  belongs_to :tree
  belongs_to :giveaway
end
