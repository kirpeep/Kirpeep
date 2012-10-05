####################################################
# Model::Review                                    #
# Desc: Review for an exchange                     #
# Comments: Base off message.rb                    #
####################################################

class Review < ActiveRecord::Base
  attr_accessible :reviewID, :exchangeID, :profileID, :review
  belongs_to :exchange
  #Does this cover response to Reviews - both reviewer and responder.
  #Reviewer needs to be able to delete this from view but not model.
  
  validates :reviewID, :presence => true
  validates :exchangeID, :presence => true
  validates :profileID, :presence => true, :uniqueness => true
  validates :review, :presence => true, :uniqueness => true

end
