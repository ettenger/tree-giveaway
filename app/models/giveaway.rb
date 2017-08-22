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

  def url
    "#{Rails.application.config.base_url}/giveaways/#{self.id}"
  end

  def valid_codes_arr
    self.valid_codes.split(",")
  end

  def code_is_valid?(user_code)
    self.valid_codes_arr.include? user_code
  end

  def code_is_used?(user_code)
    self.used_codes.split(",").include? user_code
  end

  # don't forget to save after using
  def use_code!(user_code)
    self.valid_codes = self.valid_codes_arr.reject { |code| code == user_code }.join(",")
    
    if !self.used_codes
      self.used_codes = user_code
    else
      self.used_codes += ",#{user_code}"
    end
  end

  def valid_one_time_links
    self.valid_codes_arr.map { |code| "#{self.url}?code=#{code}"}
  end

  def generate_random_codes(num)
    codes = []
    num.times do |i|
      codes << ('a'..'z').to_a.shuffle[0,8].join
    end
    codes
  end

  # don't forget to save after using
  def set_random_codes!
    self.valid_codes = self.generate_random_codes(100).join(",")
  end

end
