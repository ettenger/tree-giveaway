class CreateJoinTableTreeGiveaway < ActiveRecord::Migration
  def change
    create_join_table :trees, :giveaways do |t|
      # t.index [:tree_id, :giveaway_id]
      # t.index [:giveaway_id, :tree_id]
    end
  end
end
