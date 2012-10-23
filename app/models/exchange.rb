#################################################
# Model::Exchagne								#
# Desc: Base class for all other exchanges		#
# Comments:, 									#
#################################################

class Exchange < ActiveRecord::Base
  attr_accessible :exchange_items_attributes, :messages_attributes, :initUser, :targUser, :init_list_id, :targ_list_id, :type
  #has_many_and_belongs_to_many :need
  #has_many_and_belongs_to_many :offer
  has_many :exchange_items
  has_many :messages 
  accepts_nested_attributes_for :exchange_items
  accepts_nested_attributes_for :messages
end
