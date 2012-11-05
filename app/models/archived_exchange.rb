###############################################
# Model::Exchange                             #
# Decs: Final stage for exchanges			  #
# Comments:    								  #
###############################################
class ArchivedExchange < Exchange
  attr_accessible :reviews_attributes,:initUser, :targUser, :init_list_id, :targ_list_id, :type, :quantity, :quantityUnit, :initComp, :targComp, :initCode, :targCode, :time, :cost, :ease, :overall, :comment, :type_when_term

  has_many :reviews, :dependent => :destroy
end
