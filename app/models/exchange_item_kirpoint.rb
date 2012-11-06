class ExchangeItemKirpoint < ActiveRecord::Base
  attr_accessible :exchange_id, :targ_user_id, :user_listing_id, :init_user_id, :kirpoints_amount

  validates :init_user_id, :presence => true
  validates :targ_user_id, :presence => true
  validates :kirpoints_amount, :presence => true
end
