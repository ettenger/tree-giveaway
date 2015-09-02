class Giveaway < ActiveRecord::Base
  has_and_belongs_to_many :trees
  has_many :requests

def trees_remaining
  self.trees.map(&:stock).reduce(&:+)
end

def out_of_stock?
  self.trees_remaining < 1
end

def trees_reserved
  self.requests.count + self.requests.map(&:tree2).reject(&:nil?).count
end

def full?
  if self.tree_limit.nil?
    false
  else
    self.trees_reserved >= self.tree_limit
  end
end

def closed?
  Time.now > self.close_time
end

def over?
  Time.now > self.end_time
end

end
