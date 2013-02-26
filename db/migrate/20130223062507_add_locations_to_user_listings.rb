class AddLocationsToUserListings < ActiveRecord::Migration
	def change
		add_column :user_listings, :latitude,  :float #you can change the name, see wiki
		add_column :user_listings, :longitude, :float #you can change the name, see wiki
		add_column :user_listings, :gmaps, :boolean #not mandatory, see wiki
	end
end
