class Tree < ActiveRecord::Base
  has_and_belongs_to_many :giveaways
  has_many :requests, ->(tree){where("requests.tree_id=? OR requests.tree2_id=?", tree.id, tree.id)}
  has_attached_file :image, :styles => { :large => "300x300>", :medium => "200x200>", :thumb => "100x100>" }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
