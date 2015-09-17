class Request < ActiveRecord::Base
  belongs_to :tree
  belongs_to :giveaway

  validates :first_name, :last_name, :phone_number, :referral,
            :mailing_street1, :mailing_city, :mailing_state, :mailing_zip,
            :planting_street1, :planting_city, :planting_state, :planting_zip,
            presence: true
  validates :tree_id, presence: { message: "Please select a tree" }, numericality: { only_integer: true }
  validates :email,
            presence: true,
            :email_format => { :message => "Invalid email address" }
  validates :different_address, inclusion: { in: [true, false, "true", "false"] }

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def tree_name
    self.tree.name
  end

  def tree2
    Tree.find(self.tree2_id) if self.tree2_id
  end

  def tree2_name
    self.tree2.name if self.tree2
  end
  
  def tree_names
    if self.tree2
      if self.tree2 == self.tree
        "two #{self.tree_name} trees"
      else
        "#{article(self.tree_name)} #{self.tree_name} and #{article(self.tree2_name)} #{self.tree2_name}"
      end
    else
      "#{article(self.tree_name)} #{self.tree_name}"
    end
  end

  def giveaway_name
    self.giveaway.name
  end

  def mailing_address
    "#{self.mailing_street1} #{self.mailing_street2}\n#{self.mailing_city}, #{self.mailing_state} #{self.mailing_zip}"
  end

  def planting_address
    "#{self.planting_street1} #{self.planting_street2}\n#{self.planting_city}, #{self.planting_state} #{self.planting_zip}"
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      columns = %w(first_name last_name email phone_number tree_name tree2_name mailing_street1 mailing_street2 mailing_city mailing_state mailing_zip planting_street1 planting_street2 planting_city planting_state planting_zip giveaway_name referral created_at)
      methods = columns.map(&:to_sym)
      csv << columns
      all.each do |request|
        csv << methods.each.map { |method| method.to_proc.call(request) }
      end
    end
  end

  private

  def article(following_word)
    vowels = %w(a e i o u A E I O U)
    if vowels.include? following_word[0,1]
      "an"
    else
      "a"
    end
  end


end
