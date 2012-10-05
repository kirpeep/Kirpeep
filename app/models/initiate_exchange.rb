####################################################
# Model::InitiateExchange                          #
# Desc: Initiate phase of the exchange process     #
# Comments:                                        #
####################################################

class InitiateExchange < Exchange
  attr_accessible :initUser, :targUser, :init_list_id, :targ_list_id, :type, :quantity, :quantityUnit

  #has_many_and_belongs_to_many :offer
  #belongs_to :exchange
  ##has_many :user_listings
  #has_many :users,   :through => :user_listings
  #has_many :profiles, :through => :user_listings
  validates :initUser, :presence => true
  validates :targUser, :presence => true
  validates :init_list_id, :presence => true
  validates :targ_list_id, :presence => true
end
