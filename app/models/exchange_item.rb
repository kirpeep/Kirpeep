#################################################
# Model::ExchangeItem							#
# Desc: Holds Items tied to unique exchange     #
# Comments: 									#
#################################################

class ExchangeItem < ActiveRecord::Base
  attr_accessible :exchange_id, :targ_user_id, :user_listing_id
end
