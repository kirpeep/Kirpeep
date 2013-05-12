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

  def self.percentVs(selected_listing, vs_listing)
  	selected = self.where(:listing_y => selected_listing, :listing_n => vs_listing).count
  	rejected = self.where(:listing_y => vs_listing, :listing_n => selected_listing).count
  	total = (selected+rejected < 1)? 1 : selected+rejected
  	return (selected/total)*100
  end
end
