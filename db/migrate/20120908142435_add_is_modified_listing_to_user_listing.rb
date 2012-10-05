class AddIsModifiedListingToUserListing < ActiveRecord::Migration
  def change
  	add_column :user_listings, :is_modified_exchange, :boolean, :default => false, :null => false
  end
end
