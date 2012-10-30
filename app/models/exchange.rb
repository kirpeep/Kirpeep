#################################################
# Model::Exchagne								#
# Desc: Base class for all other exchanges		#
# Comments:, 									#
#################################################

class Exchange < ActiveRecord::Base
  attr_accessible :exchange_items_attributes, :messages_attributes, :initUser, :targUser, :init_list_id, :targ_list_id, :type
  has_many :exchange_items, :dependent => :destroy
  has_one :message, :dependent=>:destroy 
  accepts_nested_attributes_for :exchange_items
  accepts_nested_attributes_for :message
end
