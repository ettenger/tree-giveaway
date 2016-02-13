class Giveaway < ActiveRecord::Base
  has_and_belongs_to_many :trees
  has_many :requests
  has_many :logos

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

  def logo1
    Logo.find(self.logo1_id) if self.logo1_id
  end

  def logo2
    Logo.find(self.logo2_id) if self.logo2_id
  end

  def logo3
    Logo.find(self.logo3_id) if self.logo3_id
  end

  def logo4
    Logo.find(self.logo4_id) if self.logo4_id
  end

  def logo5
    Logo.find(self.logo5_id) if self.logo5_id
  end

  def logo6
    Logo.find(self.logo6_id) if self.logo6_id
  end

end
