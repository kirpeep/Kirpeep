class AddKirpointsToUserListings < ActiveRecord::Migration
  def change
    add_column :user_listings, :kirpoints, :decimal
  end
end
