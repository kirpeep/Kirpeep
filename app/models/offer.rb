####################################################
# Model::Offer                                     #
# Desc: UserListing of type offer                  #
# Comments:                                        #
####################################################

class Offer < UserListing
	include SearchHelper

	attr_accessible :inventoryCount, :is_deleted

	#paperclip
	  has_attached_file :photo,
	     :styles => {
	       :thumb => "100x100#",
	       :small  => "40x40" }
    
	validates :inventoryCount, :length => {:minimum => 1}

	
end
