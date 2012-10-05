####################################################
# Model::ModifiedExchange                          #
# Desc: Modification of initiated exchange         #
# Comments:                                        #
####################################################

class ModifiedExchange < ActiveRecord::Base
  attr_accessible :modificationID, :exchangeID, :timeModified, :itemIDModified, :modification, :prevModification
	belongs_to :exchange
	#Where do we use Need, Offer, ExchangeItem, Rating, and Review here?
	#What changes need to be made in the above Models if we change anything here?

  validates :modificationID, :presence =>true, :uniqueness => true
  validates :exchangeID, :presence => true
  validates :timeModified, :presence => true, :uniqueness => true
  validates :itemIDModified, :presence => true
  validates :prevModification, :presence => true

  
end
