####################################################
# Model::ExchangeMessageLink                       #
# Desc: Link Table that ties messages to exchanges #
# 												   #
####################################################

class ExchangeMessageLink < ActiveRecord::Base
  attr_accessible :exchange_id, :message_id
end
