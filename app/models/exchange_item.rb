#################################################
# Model::ExchangeItem							#
# Desc: Holds Items tied to unique exchange     #
# Comments: 									#
#################################################

class ExchangeItem < ActiveRecord::Base
  attr_accessible :exchange_id, :targ_user_id, :user_listing_id

  belongs_to :exchange
  belongs_to :initiate_exchange
  belongs_to :modified_exchange
  belongs_to :perform_exchange
  belongs_to :rate_exchange
  belongs_to :archived_exchange


end
