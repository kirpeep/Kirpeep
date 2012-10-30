####################################################
# Model::InitiateExchange                          #
# Desc: Initiate phase of the exchange process     #
# Comments:                                        #
####################################################

class InitiateExchange < Exchange
  attr_accessible :initUser, :targUser, :init_list_id, :targ_list_id, :type, :quantity, :quantityUnit

  
  validates :initUser, :presence => true
  validates :targUser, :presence => true
end
