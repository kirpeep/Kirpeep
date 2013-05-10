####################################################
# Model::UserListing                               #
# Desc: Offers and needs posted by users           #
# Comments:                                        #
####################################################

class UserListing < ActiveRecord::Base
       
	attr_accessible :type, :profile_id, :user_id, :inventoryCount, :listingType, :photo_file_name, :photo_content_type, :photo_file_size, :updated_at, :delta, :is_modified_exchange, :description, :title, :imgURL, :availableUntil, :listingtype, :photo, :kirpoints, :is_deleted, :category, :created_at, :shippable, :longitude, :latitude, :gmaps


	belongs_to :profile
	has_many :exchanges
	has_one :user, :through => :profile
	has_many :exchangeItems
	has_many :exchanges, :through => :exchangeItem
	has_many :assets
	accepts_nested_attributes_for :assets
	acts_as_gmappable :validation => false

	#paperclip
	has_attached_file :photo,
	:styles => {
		:thumb=> "100x100#",
		:small  => "400x400>" }

	searchable do 
		text :title, :description 
		#string :type 
		string :category
		boolean :is_deleted
		time :created_at
		text :username do
			user.name
		end
		text :group do
			user.profile.group
		end
		text :sector do
			user.profile.sector
		end
		text :location do
			user.profile.location
		end
		text :zip do
			user.profile.zipcode
		end
		text :education do
			user.profile.education
		end
	end

	validates :description, :presence => true#, :length => {:maximum =>180}
	validates :title, :presence => true#, :length => {:maximum => 50}
	#validates :listingtype#, :presence => true

	def gmaps4rails_address
		"#{self.latitude}, #{self.longitude}"
	end

	def self.SearchByQuery(query)
		search = Sunspot.search(self) do
			fulltext query
			with :is_deleted, false
			order_by :created_at, :desc
			paginate :per_page => 100
		end

		return search.results
	end

	def self.SearchByQueryAndCategory(query, category)
		search = Sunspot.search(self) do
			fulltext query
			with :category, category
			all_of do
				with :is_deleted, false
			end
			order_by :created_at, :desc
			paginate :per_page => 100
		end

		return search.results
	end

	#Display Hot Listings
	#def self.DisplayHotListings(query, category)
	#	if params[:search] ==""
	#	if params[:search] =="" && params[:category] == #insert hot listing category here
	#end
			
	def self.GetDaysSinceListingCreated(listing_id)
		listing = self.find(listing_id)

		time_ago_in_words(listing.created_at)
	end

	def self.GetByUserId(id)
		listings =self.find_by_user_id(id, :conditions => {:is_deleted => false})
	end
end
