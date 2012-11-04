####################################################
# Model::PerformExchange                           #
# Desc: Perform phase of the exchange process      #
# Comments:                                        #
####################################################

class PerformExchange < Exchange
  attr_accessible :initUser, :targUser, :init_list_id, :targ_list_id, :type, :quantity, :quantityUnit, :initComp, :targComp, :initCode, :targCode
  
end
