#################################################
# Model::Exchagne								#
# Desc: Base class for all other exchanges		#
# Comments:, 									#
#################################################

class Exchange < ActiveRecord::Base
  attr_accessible :exchange_items_attributes, :message_attributes, :reviews_attributes, :initUser, :targUser, :init_list_id, :targ_list_id, :type, :initConfCode, :targConfCode
  has_many :exchange_items, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  has_one :message, :dependent => :destroy 
  accepts_nested_attributes_for :exchange_items
  accepts_nested_attributes_for :reviews
  accepts_nested_attributes_for :message
end
