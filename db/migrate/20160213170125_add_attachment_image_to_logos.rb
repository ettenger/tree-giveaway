class AddAttachmentImageToLogos < ActiveRecord::Migration
  def self.up
    change_table :logos do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :logos, :image
  end
end
