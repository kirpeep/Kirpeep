####################################################
# Model::Need                                      #
# Desc: UserListing of type need                   #
# Comments:                                        #
####################################################

class Need < UserListing
	include SearchHelper
	attr_accessible :quantity, :quantityUnit, :neededBy, :is_deleted
	
	#paperclip
	  has_attached_file :photo,
	     :styles => {
	       :thumb => "100x100#",
	       :small  => "40x40" }

	validates :quantity, :presence =>true, :length => {:minimum => 1}
	validates :quantityUnit, :presence => true
end
