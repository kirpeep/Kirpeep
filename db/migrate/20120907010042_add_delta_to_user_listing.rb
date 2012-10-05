class AddDeltaToUserListing < ActiveRecord::Migration
  def change
  	add_column :user_listings, :delta, :boolean, :default => true, :null => false
  end
end
