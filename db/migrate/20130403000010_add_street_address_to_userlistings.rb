class AddStreetAddressToUserlistings < ActiveRecord::Migration
  def change
    add_column :user_listings, :street_address, :string
  end
end
