class AddShippableToUserListings < ActiveRecord::Migration
  def change
    add_column :user_listings, :shippable, :boolean
  end
end
