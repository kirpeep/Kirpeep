####################################################
# Model::Rating                                    #
# Desc: Rating of an exchange                      #
# Comments: RATINGS ARE NOW STORED IN EXCHANGE     #
#           AS OF 9/30/2012                        #
####################################################

class Rating < ActiveRecord::Base
  attr_accessible :ratingID, :exchangeID, :profileID, :rateTime, :rateMoney, :rateEase, :rateSatisfaction
  belongs_to :exchange

  validates :ratingID, :presence => true, :uniqueness => true
  validates :exchangeID, :presence => true, :uniqueness => true
  validates :profileID, :presence => true
  validates :rateTime, :presence => true, :inclusion => {:in =>1..5} #Do the Time, Money, Ease, and Satisfaction ratings need to be checked for uniqueness?
  validates :rateMoney, :presence => true, :inclusion => {:in =>1..5}
  validates :rateEase, :presence => true, :inclusion => {:in =>1..5}
  validates :rateSatisfaction, :presence => true, :inclusion => {:in =>1..5}

end
