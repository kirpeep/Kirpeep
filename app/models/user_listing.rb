####################################################
# Model::UserListing                               #
# Desc: Offers and needs posted by users           #
# Comments:                                        #
####################################################

class UserListing < ActiveRecord::Base
	include SearchHelper

	attr_accessible :type, :description, :title, :imgURL, :availableUntil, :listingtype, :photo

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
       
	define_index do 
		indexes title
		indexes description
		indexes type
		indexes user.profile.location, :as => :user_location
		indexes user.profile.education, :as => :user_education
		indexes user.name, :as => :user_name
		indexes user.email, :as => :user_email

		set_property :delta => true
	end
		
	validates :description, :presence => true, :length => {:maximum =>180}
	validates :title, :presence => true, :length => {:maximum => 50}
	#validates :listingtype#, :presence => true


	#def self.search(search)
  	#	if search
    #		where('title LIKE ?', "%#{search}%")
  	#	else
    #		scoped
  	#	end
	#end
end