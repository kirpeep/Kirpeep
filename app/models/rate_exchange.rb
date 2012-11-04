####################################################
# Model::RateExchange                              #
# Desc: Rate phase of the exchange process         #
# Comments:                                        #
####################################################

class RateExchange < Exchange
  attr_accessible :initUser, :targUser, :init_list_id, :targ_list_id, :type, :quantity, :quantityUnit, :initComp, :targComp, :initCode, :targCode, :time, :cost, :ease, :overall, :comment
  
end
