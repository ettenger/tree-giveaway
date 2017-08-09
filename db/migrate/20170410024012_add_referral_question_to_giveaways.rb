class AddReferralQuestionToGiveaways < ActiveRecord::Migration
  def change
    add_column :giveaways, :referral_question, :text
  end
end
