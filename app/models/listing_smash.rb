class ListingSmash < ActiveRecord::Base
  attr_accessible :user_id, :listing_y, :listing_n, :reactiontime
    
  def self.add(userId, listing_y, listing_n, time)
     @action = Action.new
     @action.user_id = userId
     @action.listing_y = listing_y
     @action.listing_n = listing_n
     @action.reactiontime = time
     @action.save
  end
end
