####################################################
# Model::UserListing                               #
# Desc: Offers and needs posted by users           #
# Comments:                                        #
####################################################

class UserListing < ActiveRecord::Base
       
	attr_accessible :type, :description, :title, :imgURL, :availableUntil, :listingtype, :photo, :kirpoints, :is_deleted, :category

	belongs_to :profile
	has_many :exchanges
	has_one :user, :through => :profile
	has_many :exchangeItems
	has_many :exchanges, :through => :exchangeItem
	has_many :assets
	accepts_nested_attributes_for :assets
 
	#paperclip
	  has_attached_file :photo,
	     :styles => {
	       :thumb=> "100x100#",
	       :small  => "400x400>" }
       
	searchable do 
		text :title, :description, :type, :category
		boolean :is_deleted
		time :created_at
        
		#indexes user.profile.location, :as => :user_location
		#indexes user.profile.zipcode, :as => :zipcode

	end
		
	validates :description, :presence => true, :length => {:maximum =>180}
	validates :title, :presence => true, :length => {:maximum => 50}
	#validates :listingtype#, :presence => true

	def self.GetAllByQuery(query)
	  search = self.search do
	    fulltext query
            with :is_deleted, '0'
	    order_by :created_at, :desc
	    paginate :per_page => 100
	  end
          
          return search.results
	end
end
