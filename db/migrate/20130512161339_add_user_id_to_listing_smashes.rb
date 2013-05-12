class AddUserIdToListingSmashes < ActiveRecord::Migration
  def change
    add_column :listing_smashes, :user_id, :integer
  end
end
