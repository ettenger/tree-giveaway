class Giveaway < ActiveRecord::Base
  has_and_belongs_to_many :trees
  has_many :requests
  has_many :logos

  def trees_remaining
    self.trees.select {|tree| tree.stock }.map(&:stock).reduce(&:+)
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

  def logos
    [self.logo1_id, self.logo2_id, self.logo3_id, self.logo4_id,
       self.logo5_id, self.logo6_id].reject(&:blank?).map { |logo_id| Logo.find(logo_id) }
  end

end
