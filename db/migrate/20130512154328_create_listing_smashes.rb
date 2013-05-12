class CreateListingSmashes < ActiveRecord::Migration
  def change
    create_table :listing_smashes do |t|
      t.integer :listing_y
      t.integer :listing_n
      t.integer :reactiontime
      t.timestamps
    end
  end
end
