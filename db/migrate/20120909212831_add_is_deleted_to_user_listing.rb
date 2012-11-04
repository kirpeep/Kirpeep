class AddIsDeletedToUserListing < ActiveRecord::Migration
  def change
  	add_column :user_listings, :is_deleted, :boolean, :default => false, :null => false
  end
end
