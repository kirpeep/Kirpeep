####################################################
# Model::TimeStamp                                 #
# Desc: Table holding all time stamps              #
# Comments: 9/30/12 Not sure how necesary this     #
# table is. It does make it easier to see a large  #
# amount of data so it will need to be implemented #
# for analysis                                     # 
####################################################

class TimeStamp < ActiveRecord::Base
  attr_accessible :exchangeID, :timeInitiated, :timeTerminated, :timeAccepted, :timeModified, :timeCompleted, :timeReviewed, :timeRated
  belongs_to :exchange
  belongs_to :modifiedExchange
  belongs_to :message
  belongs_to :rating
  belongs_to :review
  belongs_to :exchangeItem
  belongs_to :searchQuery 
  belongs_to :initiateExchange 
  #Double check these associations and let me know if we're missing any.

  validates :exchangeID, :presence => true, :uniqueness => true

end
