class Tree < ActiveRecord::Base
  has_and_belongs_to_many :giveaways
  has_many :requests, ->(tree){where("requests.tree_id=? OR requests.tree2_id=?", tree.id, tree.id)}
end
