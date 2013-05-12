class ListingSmash < ActiveRecord::Base
  attr_accessible :user_id, :listing_y, :listing_n, :reactiontime
    
  def self.add(userId, listing_y, listing_n, time)
     @ls = ListingSmash.new
     @ls.user_id = userId
     @ls.listing_y = listing_y
     @ls.listing_n = listing_n
     @ls.reactiontime = time
     @ls.save
  end
end
