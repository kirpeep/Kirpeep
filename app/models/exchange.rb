#################################################
# Model::Exchagne								#
# Desc: Base class for all other exchanges		#
# Comments:, 									#
#################################################

class Exchange < ActiveRecord::Base
  attr_accessible :initUser, :targUser, :init_list_id, :targ_list_id, :type
  #has_many_and_belongs_to_many :need
  #has_many_and_belongs_to_many :offer

  has_many :messages 
end
