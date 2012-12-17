class AddCategoryToUserListings < ActiveRecord::Migration
  def change
    add_column :user_listings, :category, :string
  end
end
