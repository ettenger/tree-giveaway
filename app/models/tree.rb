class Tree < ActiveRecord::Base
  has_and_belongs_to_many :giveaways
  belongs_to :request
end
